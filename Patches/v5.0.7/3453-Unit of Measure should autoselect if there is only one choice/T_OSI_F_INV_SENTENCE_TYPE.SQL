update t_osi_f_inv_sentence_type set uom_default='22200000FIH',uom_lock='Y'
  where code IN('DOP','CONFR');
commit;