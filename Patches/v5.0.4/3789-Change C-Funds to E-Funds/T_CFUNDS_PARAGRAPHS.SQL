update t_cfunds_paragraphs set content=replace(content,'C-funds','E-funds') where content like '%C-funds%';
commit;