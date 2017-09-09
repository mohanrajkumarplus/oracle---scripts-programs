SET SERVEROUTPUT ON;
declare

cursor cur_object_name IS
SELECT ROWID,TEXT_VALUE
FROM TEST_TABLE2 ;

     TYPE OBJECT_ID_T IS TABLE OF TEST_TABLE2.TExT_VALUE%TYPE;
     
     TEXT_VALUE_TBL OBJECT_ID_T;
     
     TYPE ROW_ID_T IS TABLE OF varchar2(18);
     
     ROWID_TBL row_id_t;
     
     
  BEGIN
  DBMS_OUTPUT.PUT_LINE('FIRST');
  DBMS_APPLICATION_INFO.SET_MODULE(MODULE_NAME => 'data masking',
  action_name => 'data changes');
  DBMS_OUTPUT.PUT_LINE('OUTER');
  OPEN cur_object_name;
  LOOP
     FETCH CUR_OBJECT_NAME BULK COLLECT INTO ROWID_TBL, TEXT_VALUE_TBL LIMIT 100;
   DBMS_OUTPUT.PUT_LINE('FETCH');
--   FOR I IN 1.. ROWID_TBL.COUNT
--   LOOP
--   DBMS_OUTPUT.PUT_LINE(ROWID_TBL(i) || ' '|| text_value_tbl(i));
--   END LOOP;
--   
     FORALL i IN 1 .. ROWID_TBL.COUNT
        UPDATE TEST_TABLE2
        SET text_value = translate(upper(TEXT_VALUE_TBL(i)),'ABCDEFGHIJKLMNOPQRST','KLMNOPQRSTABCDEFGHIJ')
        WHERE ROWID = ROWID_TBL(i);
        dbms_application_info.set_action(action_name => sql%rowcount);
        commit;
        DBMS_OUTPUT.PUT_LINE('UPDATE');
    EXIT WHEN CUR_OBJECT_NAME%NOTFOUND;
  END LOOP;
  CLOSE cur_object_name;       
         
  END;
