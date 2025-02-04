-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "CORE_LIST" is
/*
    Core_List - Basic List Functions.

  ??-???-1994 RWH   Original version and early mods made at
                     Aristech in the form of an SQL*Forms 3.0
                     reference form called ZZZ_LIST. Migrated
                     to a database package in late 97 (Eiden).
  10-Aug-1998 RWH   Added Column Offsets to Print_List.
  12-Jun-1999 ERC   Added Sorted List Functionality.
  07-Feb-2003 RWH   Added Get_Item_Index.
  31-Aug-2005 RWH   Adapted from legacy package (LIST).
                     Pragmas not needed in 10g.
  31-Jul-2008 RWH   Added Convert_To_List.
  18-Dec-2008 RWH   Made Add_Item_to_List_Front public.
  20-Aug-2012 TJW   CR#4104 - Added pSep as a parameter so we can change the seperator for the lists, 
                     however it defaults to '~'.
*/
    function ADD_ITEM_TO_LIST(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean;

    function ADD_ITEM_TO_LIST_FRONT(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean;

    function ADD_ITEM_TO_LIST_SORTED(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean;

    function FIND_ITEM_IN_LIST(ITEM in varchar2, list in varchar2, pSep in varchar2:='~')
        return boolean;

    function POP_LIST_ITEM(list in out varchar2, pSep in varchar2:='~')
        return varchar2;

    function REMOVE_ITEM_FROM_LIST(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean;

    function COUNT_LIST_ELEMENTS(list in varchar2, pSep in varchar2:='~')
        return number;

    function GET_ITEM_INDEX(list in varchar2, ITEM in varchar2, pSep in varchar2:='~')
        return number;

    function GET_LIST_ELEMENT(list in varchar2, NDX in number, pSep in varchar2:='~')
        return varchar2;

    procedure PRINT_LIST(list in varchar2, FRST_OFF in number := 0, REST_OFF in number := 0, pSep in varchar2:='~');

/*
    Convert_To_List: Converts the string in P_SOURCE to a list by replacing all occurances of P_SEP
        with "~". Also insures that the resulting list starts and ends with a "~" (unless it is null).
*/
    function CONVERT_TO_LIST(P_SOURCE in varchar2, P_SEP in varchar2, pSep in varchar2:='~')
        return varchar2;
/*
pragma restrict_references( Add_Item_To_List, WNDS, WNPS );
pragma restrict_references( Find_Item_In_List, WNDS, WNPS );
pragma restrict_references( Pop_List_Item, WNDS, WNPS );
pragma restrict_references( Remove_Item_From_List, WNDS, WNPS );
pragma restrict_references( Count_List_Elements, WNDS, WNPS );
pragma restrict_references( Get_List_Element, WNDS, WNPS );
*/
end CORE_LIST;
/


CREATE OR REPLACE PACKAGE BODY "CORE_LIST" is
/*
  Core_List - Basic List Functions.
  ??-???-1994 RWH Original version and early mods made at
                   Aristech in the form of an SQL*Forms 3.0
                   reference form called ZZZ_LIST. Migrated
                   to a database package in late 97 (Eiden).
  10-Aug-1998 RWH Added Column Offsets to Print_List.
  12-Jun-1999 ERC Added Sorted List Functionality.
  07-Feb-2003 RWH Added Get_Item_Index.
  31-Aug-2005 RWH Adapted from legacy package (LIST).
                   Pragmas not needed in 10g.
  04-Apr-2008 RWH Remove/relax size constraints in several routines.
  31-Jul-2008 RWH Added Convert_To_List.
  20-Aug-2012 TJW CR#4104 - Added pSep as a parameter so we can change the seperator for the lists, 
                   however it defaults to '~'.
*/
    function ADD_ITEM_TO_LIST(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean is
    begin
        if list is null then
            list := pSep;
        end if;

        list := list || ITEM || pSep;
        return true;
    exception
        when others then
            return false;
    end;

    function ADD_ITEM_TO_LIST_FRONT(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean is
    begin
        if list is null then
            list := pSep;
        end if;

        list := pSep || ITEM || list;
        return true;
    exception
        when others then
            return false;
    end;

    function FIND_ITEM_IN_LIST(ITEM in varchar2, list in varchar2, pSep in varchar2:='~')
        return boolean is
    begin
        if instr(list, pSep || ITEM || pSep) > 0 then
            return true;
        else
            return false;
        end if;
    end;

    function POP_LIST_ITEM(list in out varchar2, pSep in varchar2:='~')
        return varchar2 is
        ITEM   varchar2(32767);
        LOC    number;
    begin
        LOC := instr(nvl(list, pSep), pSep, 1, 2);

        if LOC = 0 then
            return null;
        else
            ITEM := substr(list, 2, LOC - 2);
            list := substr(list, LOC);
            return ITEM;
        end if;
    end;

    function REMOVE_ITEM_FROM_LIST(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean is
        LOC   number;
        LST   varchar2(32767);
    begin
        LOC := instr(list, pSep || ITEM || pSep);

        if LOC = 0 then
            return false;
        else
            LST := substr(list, 1, LOC) || substr(list, LOC + length(ITEM) + 2);
            list := LST;
            return true;
        end if;
    end;

    function COUNT_LIST_ELEMENTS(list in varchar2, pSep in varchar2:='~')
        return number is
        NDX   number := 1;
        CNT   number := 0;
    begin
        while NDX < length(list)
        loop
            if substr(list, NDX, 1) = pSep then
                CNT := CNT + 1;
            end if;

            NDX := NDX + 1;
        end loop;

        return CNT;
    end;

    function GET_ITEM_INDEX(list in varchar2, ITEM in varchar2, pSep in varchar2:='~')
        return number is
        NDX   number := 1;
        CNT   number := 0;
    begin
        CNT := COUNT_LIST_ELEMENTS(list);

        if CNT = 0 then
            return CNT;                                                            -- list is empty
        end if;

        while NDX <= CNT
        loop
            if ITEM = GET_LIST_ELEMENT(list, NDX, pSep) then
                return NDX;
            end if;

            NDX := NDX + 1;
        end loop;

        return 0;                                                                -- item not in list
    end;

    function GET_LIST_ELEMENT(list in varchar2, NDX in number, pSep in varchar2:='~') return varchar2 is

         LOC    number;
         LOC2   number;

    begin
         LOC2 := instr(list, pSep, 1, NDX + 1);

         if LOC2 = 0 then
           return null;
         else
           LOC := instr(list, pSep, 1, NDX);
           return substr(list,(LOC + length(pSep)),(LOC2 -(LOC + length(pSep))));
         end if;
    end;

    procedure PRINT_LIST(list in varchar2, FRST_OFF in number, REST_OFF in number, pSep in varchar2:='~') is
        WRK   varchar2(32767) := list;
        ITM   varchar2(32767) := null;
        FF    boolean         := true;
    begin
        ITM := POP_LIST_ITEM(WRK, pSep);

        while ITM is not null
        loop
            if FF then
                ITM := lpad(' ', FRST_OFF) || ITM;
                FF := false;
            else
                ITM := lpad(' ', REST_OFF) || ITM;
            end if;

            if length(ITM) > 255 then
                ITM := substr(ITM, -255);
            end if;

            if substr(ITM, 1, 1) = ' ' then
                ITM := '.' || substr(ITM, 2);              -- SQL*Plus won't display leading blanks
            end if;

            dbms_output.PUT_LINE(ITM);
            ITM := POP_LIST_ITEM(WRK, pSep);
        end loop;
    end;

    function ADD_ITEM_TO_LIST_SORTED(ITEM in varchar2, list in out varchar2, pSep in varchar2:='~')
        return boolean is
        TEMP_LIST      varchar2(32767);
        TEMP_ELEMENT   varchar2(32767);
        RTN            boolean;
    begin
        if list is null then
            list := pSep;
            list := list || ITEM || pSep;
        else
            TEMP_ELEMENT := POP_LIST_ITEM(list, pSep);

            while TEMP_ELEMENT < ITEM
            loop
                RTN := ADD_ITEM_TO_LIST_FRONT(TEMP_ELEMENT, TEMP_LIST);
                TEMP_ELEMENT := POP_LIST_ITEM(list, pSep);
            end loop;

            RTN := ADD_ITEM_TO_LIST_FRONT(TEMP_ELEMENT, list);
            RTN := ADD_ITEM_TO_LIST_FRONT(ITEM, list);

            while COUNT_LIST_ELEMENTS(TEMP_LIST) > 0
            loop
                RTN := ADD_ITEM_TO_LIST_FRONT(POP_LIST_ITEM(TEMP_LIST, pSep), list);
            end loop;

            list := replace(list, pSep || pSep, pSep);
        end if;

        return true;
    exception
        when others then
            return false;
    end;

    function CONVERT_TO_LIST(P_SOURCE in varchar2, P_SEP in varchar2, pSep in varchar2:='~')
        return varchar2 is
        V_LIST   varchar2(32767);
    begin
        if P_SOURCE is not null and P_SEP is not null then
            V_LIST := replace(P_SOURCE, P_SEP, pSep);

            if substr(V_LIST, 1, 1) <> pSep then
                V_LIST := '~' || V_LIST;
            end if;

            if substr(V_LIST, -1) <> pSep then
                V_LIST := V_LIST || pSep;
            end if;
        end if;

        return V_LIST;
    end CONVERT_TO_LIST;
end CORE_LIST;
/

