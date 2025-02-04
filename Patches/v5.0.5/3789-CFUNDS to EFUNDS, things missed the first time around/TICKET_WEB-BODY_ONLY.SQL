set define off;

CREATE OR REPLACE PACKAGE BODY "TICKET_WEB" as
/**
 * Air Force - Office Of Special Investigation
 *     _____  ___________________    _________.___
 *    /  _  \ \_   _____/\_____  \  /   _____/|   |
 *  /  /_\  \ |    __)   /   |   \ \_____  \ |   |
 * /    |    \|     \   /    |    \/        \|   |
 * \____|__  /\___  /   \_______  /_______  /|___|
 *         \/     \/            \/        \/
 *  Investigative Information Management System
 *  .___________    _____    _________
 *  |   \_____  \  /     \  /   _____/
 *  |   |/  ____/ /  \ /  \ \_____  \
 *  |   /       \/    Y    \/        \
 *  |___\_______ \____|__  /_______  /
 *              \/       \/        \/
 *  Ticket Authentication - Web Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       TICKET_WEB
   PURPOSE:    Supports Ticket Authentication in I2MS for Web Based Applications

   REVISIONS:
   Date         Author           Description
   ----------   ---------------  ------------------------------------
   09/30/2008   Richard Dibble   Created this package.
   10/21/2009   Richard Dibble   Added rdr
   15-Nov-2011  Tim Ward         CR#3789 - Change CFunds to EFunds
******************************************************************************/
    procedure create_cookie(ptkt in varchar2) is
    begin
        htp.p('Cookie Sent.');
    end create_cookie;

    procedure view_cookie(ptkt in varchar2) is
    begin
        htp.p('Cookie Value: [' || ticket_pkg.get_cookie('TICKET') || ']');
    end;
    
    procedure rdr(ptkt in varchar2, p_par in varchar2, p_type in varchar2) is
    begin
        htp.p('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">');
        htp.p('<html>');
        htp.p('<head>');
        htp.p('<title>Your Page Title</title>');
        htp.p('<meta http-equiv="REFRESH" content="0;url=' || p_par || '"></HEAD>');
        htp.p('<BODY>');
        if (upper(p_type) = 'CFN') then
            htp.p('Transfering you to EFunds, please wait.');
        else
            htp.p('Transfering you now, please wait. ');
        end if;
        htp.p('</BODY>');
        htp.p('</HTML>');
    end rdr;
end ticket_web;
/