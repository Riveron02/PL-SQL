--Para el laboratorio No.4

CREATE SEQUENCE trigger_aucolabs
START WITH 1
INCREMENT BY 1;

create table auditoriacolabs (
    transaccion NUMBER PRIMARY KEY NOT NULL,
    id_colaborador NUMBER,
    estatus_ant CHAR,
    estatus_act CHAR,
    salariomensual_ant NUMBER(15, 2),
    salariomensual_act NUMBER(15, 2),
    montomodif NUMBER(15, 2),
    tipotransaction VARCHAR2(100),
    usuario varchar2(20),
    fecha_transaccion TIMESTAMP(4)
);

--Triger para el auditar los cambios en la tabla colaboradores 
CREATE OR REPLACE TRIGGER add_transaction
AFTER INSERT OR UPDATE OR DELETE ON colaboradores
FOR EACH ROW
BEGIN

IF INSERTING THEN 
INSERT INTO auditoriacolabs (transaccion, id_colaborador, estatus_ant, estatus_act, salariomensual_ant, salariomensual_act, montomodif, tipotransaction, usuario, fecha_transaccion)
VALUES (trigger_aucolabs.nextval, :new.id_codcolaborador, :new.status, NULL, :new.salario_mensual, NULL, NULL, 'Insert', user, current_timestamp);
END IF;

IF UPDATING THEN
INSERT INTO auditoriacolabs (transaccion, id_colaborador, estatus_ant, estatus_act, salariomensual_ant, salariomensual_act, montomodif, tipotransaction, usuario, fecha_transaccion)
VALUES (trigger_aucolabs.nextval, :old.id_codcolaborador, :old.status, :new.status, :old.salario_mensual, :new.salario_mensual, (:new.salario_mensual - :old.salario_mensual), 'Update', user, current_timestamp);
END IF;

IF DELETING THEN
INSERT INTO auditoriacolabs (transaccion, id_colaborador, estatus_ant, estatus_act, salariomensual_ant, salariomensual_act, montomodif, tipotransaction, usuario, fecha_transaccion)
VALUES (trigger_aucolabs.nextval, :old.id_codcolaborador, :old.status, NULL, :old.salario_mensual, NULL, NULL, 'Delete', user, current_timestamp);
END IF;


EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END add_transaction;
/

UPDATE colaboradores SET
status = 'V'
WHERE id_codcolaborador = 61;

DELETE FROM colaboradores
WHERE id_codcolaborador = 61;

--Para el laboratorio No.6

CREATE SEQUENCE tri_audprestamo
START WITH 1
INCREMENT BY 1;

CREATE TABLE auditoriaprestamos (
    transaccion_pre NUMBER PRIMARY KEY NOT NULL,
    id_cliente NUMBER,
    Noprestamo NUMBER,
    cant_aprobada_ant NUMBER(15, 2),
    cant_aprobada_act NUMBER(15, 2),
    montomodif_ca NUMBER(15, 2),
    cant_pagada NUMBER(15, 2),
    saldo_ant NUMBER(15, 2),
    saldo_act NUMBER(15, 2),
    montomodif NUMBER(15, 2),
    interes_pagado NUMBER(15, 2),
    tipotransaction VARCHAR2(100),
    usuario VARCHAR(20),
    fecha_transpre TIMESTAMP(4)
);

--Trigger para auditar los insert de la tabla prestamo
CREATE OR REPLACE TRIGGER add_preauditoria
AFTER INSERT OR UPDATE OR DELETE ON Prestamo
FOR EACH ROW
BEGIN

IF INSERTING THEN
INSERT INTO auditoriaprestamos (transaccion_pre, id_cliente, Noprestamo, cant_aprobada_ant, cant_aprobada_act, cant_pagada, saldo_ant, saldo_act, montomodif, interes_pagado, tipotransaction, usuario, fecha_transpre)
VALUES (tri_audprestamo.nextval, :new.Pre_Cli_ID, :new.Pre_NPrestamos, :new.Pre_CantAprobada, NULL, NULL, :new.Pre_Saldo_Actual, NULL, NULL, NULL, 'Insert', user, current_timestamp);
END IF;

IF UPDATING THEN
INSERT INTO auditoriaprestamos (transaccion_pre, id_cliente, Noprestamo, cant_aprobada_ant,  cant_aprobada_act,
montomodif_ca, cant_pagada, saldo_ant, saldo_act, montomodif, interes_pagado, tipotransaction, usuario, fecha_transpre)
VALUES (tri_audprestamo.nextval, :old.Pre_Cli_ID, :old.Pre_NPrestamos, :old.Pre_CantAprobada, :new.Pre_CantAprobada,
(:new.Pre_CantAprobada - :old.Pre_CantAprobada), :new.Pre_CantPagada, :old.Pre_Saldo_Actual, :new.Pre_Saldo_Actual,
(:old.Pre_Saldo_Actual - :new.Pre_Saldo_Actual), :new.Pre_Interes_Pagado, 'Update', user, current_timestamp);
END IF;

IF DELETING THEN
INSERT INTO auditoriaprestamos (transaccion_pre, id_cliente, Noprestamo, cant_aprobada_ant,  cant_aprobada_act,
montomodif_ca, cant_pagada, saldo_ant, saldo_act, montomodif, interes_pagado, tipotransaction, usuario, fecha_transpre)
VALUES (tri_audprestamo.nextval, :old.Pre_Cli_ID, :old.Pre_NPrestamos, :old.Pre_CantAprobada, NULL, NULL, :old.Pre_CantPagada, :old.Pre_Saldo_Actual, NULL, NULL, :old.Pre_Interes_Pagado, 'Delete', user, current_timestamp);
END IF;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END add_preauditoria;
/

CREATE OR REPLACE TRIGGER UpdAcumulacionsuc
AFTER INSERT OR UPDATE ON Prestamo
FOR EACH ROW
DECLARE
v_Pre_Saldo_Actual Prestamo.Pre_Saldo_Actual%TYPE := 0;
BEGIN

IF :old.Pre_Saldo_Actual IS NOT NULL THEN
v_Pre_Saldo_Actual := :old.Pre_Saldo_Actual;
END IF;

--actualizar monto de la sucursal
UPDATE Sucursal SET 
Suc_MontoPrestamo = (Suc_MontoPrestamo - v_Pre_Saldo_Actual) + :new.Pre_Saldo_Actual
WHERE Suc_Cod = :new.Pre_Suc_Cod;

--actualizar el monto en la tabla suctipoprest
UPDATE Suc_TipoPrest SET
ST_Monto = (ST_Monto - v_Pre_Saldo_Actual) + :new.Pre_Saldo_Actual
WHERE ST_Suc_Cod = :new.Pre_Suc_Cod
AND ST_TipoPrest_Cod = :new.Pre_Cod_tipo_prestamo;

IF SQL%NOTFOUND THEN
INSERT INTO Suc_TipoPrest(ST_Suc_Cod, ST_TipoPrest_Cod, ST_Monto)
VALUES (:new.Pre_Suc_Cod, :new.Pre_Cod_tipo_prestamo, :new.Pre_Saldo_Actual);
END IF;

END UpdAcumulacionsuc;
/

CREATE OR REPLACE TRIGGER DelAcumulacionsuc
AFTER DELETE ON Prestamo
FOR EACH ROW
DECLARE
BEGIN
UPDATE Sucursal SET
Suc_MontoPrestamo = Suc_MontoPrestamo - (:old.Pre_Saldo_Actual - :old.pre_CantPagada)
WHERE Suc_Cod = :old.Pre_Suc_Cod;

UPDATE Suc_TipoPrest SET
ST_Monto = ST_Monto - (:old.Pre_Saldo_Actual - :old.pre_CantPagada)
WHERE ST_Suc_Cod = :old.Pre_Suc_Cod
AND ST_TipoPrest_Cod = :old.Pre_Cod_tipo_prestamo;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END DelAcumulacionsuc;
/

--MODIFICACIONES A LOS PROCEDIMIENTOS
--Procedimiento almacenado para la carga o insercion de los prestamos aprobados
CREATE OR REPLACE PROCEDURE AddNewPrestamo (

    p_Pre_Cli_ID Prestamo.Pre_Cli_ID%TYPE,
    p_Pre_Cod_tipo_prestamo Prestamo.Pre_Cod_tipo_prestamo%TYPE,
    p_Pre_Fecha_Apro Prestamo.Pre_Fecha_Apro%TYPE,
    p_Pre_CantAprobada Prestamo.Pre_CantAprobada%TYPE,
    p_Pre_LetraMensual Prestamo.Pre_LetraMensual%TYPE,
    p_Pre_FechaPago Prestamo.Pre_FechaPago%TYPE,
    p_Pre_Suc_Cod Prestamo.Pre_Suc_Cod%TYPE,
    p_Pre_Saldo_Actual Prestamo.Pre_Saldo_Actual%TYPE,
    p_Pre_Fecha_Mod Prestamo.Pre_Fecha_Mod%TYPE,
    p_Mensaje OUT VARCHAR2

) AS
BEGIN
INSERT INTO Prestamo(Pre_Cli_ID, Pre_Cod_tipo_prestamo, Pre_NPrestamos, Pre_Fecha_Apro, Pre_CantAprobada, Pre_LetraMensual, 
Pre_CantPagada, Pre_FechaPago, Pre_Suc_Cod, Pre_Saldo_Actual, Pre_Interes_Pagado, Pre_Fecha_Mod, Pre_Usuario)
VALUES(p_Pre_Cli_ID, p_Pre_Cod_tipo_prestamo, Seq_NPrestamos.NextVal, current_timestamp, p_Pre_CantAprobada, p_Pre_LetraMensual, 
0, p_Pre_FechaPago, p_Pre_Suc_Cod, p_Pre_Saldo_Actual, 0,  p_Pre_Fecha_Mod, User);

p_Mensaje := 'Operaciones completadas';

EXCEPTION

WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);
--p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewPrestamo;
/

--Invocacion de AddNewPrestamo 
DECLARE

v_Client_ID Prestamo.Pre_Cli_ID%TYPE := &CodDeCliente;
v_Cod_tipo_pre Prestamo.Pre_Cod_tipo_prestamo%TYPE := &CodTipoPrestamo;
v_Fecha_Apro Prestamo.Pre_Fecha_Apro%TYPE := '&FechaDeAprob';
v_CantApro Prestamo.Pre_CantAprobada%TYPE := &CantidadAprobada;
v_LetraMensual Prestamo.Pre_LetraMensual%TYPE := &LetraMensual;
v_FechaPago Prestamo.Pre_FechaPago%TYPE;
v_Suc_Cod Prestamo.Pre_Suc_Cod%TYPE := &CodSucursal;
v_Saldo_Actual Prestamo.Pre_Saldo_Actual%TYPE;
v_Fecha_Mod Prestamo.Pre_Fecha_Mod%TYPE;
v_Mensaje VARCHAR2(50);

BEGIN

v_Saldo_Actual := v_CantApro;

AddNewPrestamo(v_Client_ID, v_Cod_tipo_pre, v_Fecha_Apro, v_CantApro, v_LetraMensual,
v_FechaPago, v_Suc_Cod, v_Saldo_Actual, v_Fecha_Mod, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--Procedimiento almacenado de ACTUALIZACION de pagos
CREATE OR REPLACE PROCEDURE ActPrestamo(
    p_Mensaje OUT VARCHAR2

) AS
--Cursor de busqueda de pagos Activos
CURSOR c_Payment IS
SELECT cod_sucursal, id_transaction, id_cliente,
tipoprestamo, monto_del_pago, fechatransaction 

FROM Transacpagos 
WHERE estado = 'A';

--Toma la tasa del prestamo de la tabla prestamo aprobado
v_TasaPres Prestamo.Pre_LetraMensual%TYPE;
--Vriable para calcular el interes con la funcion calc_Int
v_IntCalc Prestamo.Pre_LetraMensual%TYPE;
--Variable para tomar la cantidad que se almacena en la tabla prestamo que se ha pagado empieza en 0
v_cantp Prestamo.Pre_CantPagada%TYPE;
--Variable para calcular la cantidad pagada al saldo que se debe
v_cantpCalc Prestamo.Pre_CantPagada%TYPE;
--Variable para tomar lo que se tiene como saldo actual en la tabla prestamo inicia con la cantida aprobada
v_Actsaldo Prestamo.Pre_Saldo_Actual%TYPE;
--Variable para calcular el saldo actual luego de la resta del monto pagado
v_ActSaldCalc Prestamo.Pre_Saldo_Actual%TYPE;
--Variable para tomar el interes que se ha pagado de la tabla prestamo
v_IntP Prestamo.Pre_Interes_Pagado%TYPE;
--Variable para sumar el interes pagado del prestamo
v_IntTotal Prestamo.Pre_Interes_Pagado%TYPE;

BEGIN
FOR v_counterPay IN c_Payment LOOP

SELECT Pre_CantPagada, Pre_LetraMensual, Pre_Saldo_Actual, Pre_Interes_Pagado INTO v_cantp, v_TasaPres, v_Actsaldo, v_IntP
FROM Prestamo
WHERE Pre_Cli_ID = v_counterpay.id_cliente
AND Pre_Cod_tipo_prestamo = v_counterpay.tipoprestamo;

--Interes calculado por la funcion
v_IntCalc := calc_Int(v_Actsaldo, v_TasaPres);

IF v_IntCalc < v_counterpay.monto_del_pago THEN
--Cantidad pagada calculada luego de restarle el interes
v_cantpCalc := v_counterpay.monto_del_pago - v_IntCalc;

ELSE
v_cantpCalc := 0;

END IF;
v_cantp := v_cantp + v_cantpCalc;
--saldo que se debe en el prestamo
v_ActSaldCalc := v_Actsaldo - v_cantpCalc;
--Interes pagados del prestamo
v_IntTotal := v_IntP + v_IntCalc;

--Actualizacion de los campos de la tabla prestamos cuando se haya insertado unpago para ese prestamo
UPDATE Prestamo SET
Pre_CantPagada = v_cantp,
Pre_Saldo_Actual = v_ActSaldCalc,
Pre_Interes_Pagado = v_IntTotal,
Pre_FechaPago = v_counterpay.fechatransaction,
Pre_Fecha_Mod = CURRENT_TIMESTAMP

WHERE Pre_Cli_ID = v_counterpay.id_cliente 
AND Pre_Cod_tipo_prestamo = v_counterpay.tipoprestamo;

/*Actualizacion de la tabla TRANSACPAGOS, para que el pago que se haya procesado 
cambie de estado y se actualice la fecha de cuando se proceso*/
UPDATE Transacpagos SET estado = 'P',
fechainsercion = CURRENT_TIMESTAMP
WHERE id_transaction = v_counterpay.id_transaction;

p_Mensaje := 'Se han realizado las operaciones';

END LOOP;

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);
--p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END ActPrestamo;
/

DECLARE
v_mensaje varchar2(50);
BEGIN
ActPrestamo(v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;
/


--Invocacion de AddNewPago
DECLARE
v_CodSucursal Transacpagos.cod_sucursal%TYPE := &CodigoDeSucursal;
v_id_cliente Transacpagos.id_cliente%TYPE := &CodigoDeCliente;
v_tipoprestamo Transacpagos.tipoprestamo%TYPE := &CodigoDeTipoPrestamo;
v_montoPago Transacpagos.monto_del_pago%TYPE := &MontoaPagar;
v_estado Transacpagos.estado%TYPE := '&EstadodePagoAoP';
v_Mensaje VARCHAR2(50);

BEGIN
--Agrega un nuevo pago
AddnewPago(v_CodSucursal, v_id_cliente, v_tipoprestamo, v_montoPago, v_estado, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/
