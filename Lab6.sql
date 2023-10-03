--MODELO FISICO
--O9
--1. Agregar el atributo edad a la tabla clientes con restricciones
ALTER TABLE Cliente ADD Cli_Edad NUMBER NOT NULL;
ALTER TABLE Cliente ADD Cli_Suc_Cod NUMBER NOT NULL;
ALTER TABLE Cliente ADD CONSTRAINT c_Edad CHECK (Cli_Edad BETWEEN 18 and 100);
--O11
ALTER TABLE Cliente ADD CONSTRAINT fk_Cli_Suc_Cod FOREIGN KEY (Cli_Suc_Cod) REFERENCES Sucursal (Suc_Cod);

--3. AGREGAR A LA TABLA CLIENTES EL ATRIBUTO Suc_Cod

--ORDEN 3
CREATE TABLE Cliente (
    Cli_ID   NUMBER          NOT NULL,
    Cli_Cedula      VARCHAR2(20)    NOT NULL,
    Cli_Nombre      VARCHAR2(25)    NOT NULL,
    Cli_Apellido    VARCHAR2(25)    NOT NULL,
    Cli_Sexo        CHAR            NOT NULL,
    Cli_Nacimiento  DATE            NOT NULL,
    Cli_Cod_Profesion NUMBER    NOT NULL,
    CONSTRAINT pk_Cli_ID PRIMARY KEY (Cli_ID),
    CONSTRAINT fk_Cli_Cod_Profesion FOREIGN KEY (Cli_Cod_Profesion) REFERENCES Profesion (Pro_Cod_Profesion),
    CONSTRAINT c_sexo CHECK (Cli_Sexo in ('M', 'F')),
    CONSTRAINT u_Cli_Cedula UNIQUE (Cli_Cedula)
   );

--ORDEN 1
CREATE TABLE Profesion (
    Pro_Cod_Profesion NUMBER NOT NULL,
    Pro_Desc_Tprof VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_Pro_Cod_Profesion PRIMARY KEY (Pro_Cod_Profesion)
);

--ORDEN 2
CREATE TABLE Type_Telefono (
    Tel_Codigo_tipo_Telefono NUMBER NOT NULL,
    Tel_Desc_Typetelefono VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_Tel_Codigo_tipo_Telefono PRIMARY KEY (Tel_Codigo_tipo_Telefono)
);

--ORDEN 4
CREATE TABLE Cli_Telefonos (
    Tel_ClienteID  NUMBER,
    TipT_ID         NUMBER,
    Tel_Numero      NUMBER,
    CONSTRAINT pk_Tel_ClienteID_TipT_ID PRIMARY KEY (Tel_ClienteID, TipT_ID),
    CONSTRAINT fk_Tel_ClienteID FOREIGN KEY (Tel_ClienteID) REFERENCES  Cliente (Cli_ID),
    CONSTRAINT fk_TipT_ID FOREIGN KEY (TipT_ID) REFERENCES Type_Telefono (Tel_Codigo_tipo_Telefono)
);

--Procedimientos para agregar un telefono a un cliente
CREATE OR REPLACE PROCEDURE AddCli_Tel (
    p_ClienteID Cli_Telefonos.Tel_ClienteID%TYPE,
    p_TipT_ID Cli_Telefonos.TipT_ID%TYPE,
    p_Tel_Numero Cli_Telefonos.Tel_Numero%TYPE,
    p_Mensaje OUT VARCHAR
) AS
BEGIN
INSERT INTO Cli_Telefonos(Tel_ClienteID, TipT_ID, Tel_Numero)
VALUES (p_ClienteID, p_TipT_ID, p_Tel_Numero);
p_Mensaje := 'Se ha insertado el Telefono:' || p_Tel_Numero || 'al cliente con id -->' || p_ClienteID;

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

COMMIT;
END AddCli_Tel;
/

--Invocacion de AddCli_Tel
DECLARE
v_ClienteID Cli_Telefonos.Tel_ClienteID%TYPE := &Idcliente;
v_TipT_ID Cli_Telefonos.TipT_ID%TYPE := &tipodetelefono;
v_Tel_Numero Cli_Telefonos.Tel_Numero%TYPE := &NUMEROTELEFONICO;
v_Mensaje VARCHAR2(100);
BEGIN
AddCli_Tel(v_ClienteID, v_TipT_ID, v_Tel_Numero, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--ORDEN 5
CREATE TABLE Type_Email (
    Ema_Codigo_tipo_Email NUMBER NOT NULL,
    Ema_Desc_TypeEmail VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_Email_Codigo_tipo_Email PRIMARY KEY (Ema_Codigo_tipo_Email)
);

--ORDEN 6
CREATE TABLE Cli_Email (
    Email_ClienteID  NUMBER,
    TypeE_ID         NUMBER,
    Email_Direccion  VARCHAR2(50),
    CONSTRAINT pk_Email_ClienteID_TypeE_ID PRIMARY KEY (Email_ClienteID, TypeE_ID),
    CONSTRAINT fk_Email_ClienteID FOREIGN KEY (Email_ClienteID) REFERENCES  Cliente (Cli_ID),
    CONSTRAINT fk_TypeE_ID FOREIGN KEY (TypeE_ID) REFERENCES Type_Email (Ema_Codigo_tipo_Email),
    CONSTRAINT u_email UNIQUE (Email_Direccion)
);

--Procedimientos para agregar un email a un cliente

CREATE OR REPLACE PROCEDURE AddCli_Email (
    p_ClienteID Cli_Email.Email_ClienteID%TYPE,
    p_TypeE_ID Cli_Email.TypeE_ID%TYPE,
    p_Email_Direccion Cli_Email.Email_Direccion%TYPE,
    p_Mensaje OUT VARCHAR
) AS
BEGIN
INSERT INTO Cli_Email(Email_ClienteID, TypeE_ID, Email_Direccion)
VALUES (p_ClienteID, p_TypeE_ID, p_Email_Direccion);
p_Mensaje := 'Se ha insertado el email:' || p_Email_Direccion ||  'al cliente con id -->' || p_ClienteID;

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

COMMIT;
END AddCli_Email;
/

--Invocacion de AddCli_Tel
DECLARE
v_ClienteID Cli_Email.Email_ClienteID%TYPE := &Idcliente;
v_TypeE_ID Cli_Email.TypeE_ID%TYPE := &tipoemail;
v_Email_Direccion Cli_Email.Email_Direccion%TYPE := '&DIRECCIONEMAIL';
v_Mensaje VARCHAR2(100);
BEGIN
AddCli_Email(v_ClienteID, v_TypeE_ID, v_Email_Direccion, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O7
CREATE TABLE Type_Prestamo (
    TyPre_Codigo_tipo_Prestamo NUMBER NOT NULL,
    TyPre_Desc_TypePrestamo VARCHAR2(50) NOT NULL,
    TyPre_Tasa NUMBER(15, 2) NOT NULL,
    CONSTRAINT pk_Codigo_tipo_Prestamo PRIMARY KEY (TyPre_Codigo_tipo_Prestamo)
);


--O8.1
--3. AGREGAR A LA TABLA Prestamo EL ATRIBUTO Suc_Cod
ALTER TABLE Prestamo ADD Pre_Suc_Cod NUMBER NOT NULL;
ALTER TABLE Prestamo ADD Pre_Saldo_Actual NUMBER(15, 2) NOT NULL;
ALTER TABLE Prestamo ADD Pre_Interes_Pagado NUMBER(15, 2) NOT NULL;
ALTER TABLE Prestamo ADD Pre_Fecha_Mod TIMESTAMP(4);
ALTER TABLE Prestamo ADD Pre_Usuario varchar2(30) NOT NULL;
ALTER TABLE Prestamo ADD CONSTRAINT fk_Pre_Suc_Cod FOREIGN KEY (Pre_Suc_Cod) REFERENCES Sucursal (Suc_Cod);

--4. Agregar a la tabla Prestamo los atributos saldoactual, interespagado, fechamodificacion
--O8
CREATE TABLE Prestamo (
    Pre_Cli_ID            NUMBER  NOT NULL,
    Pre_Cod_tipo_prestamo NUMBER NOT NULL,
    Pre_NPrestamos      NUMBER  NOT NULL,
    Pre_Fecha_Apro      TIMESTAMP(4)   NOT NULL,
    Pre_CantAprobada    NUMBER(15, 2)  NOT NULL,
    Pre_LetraMensual    NUMBER(15, 2)  NOT NULL,
    Pre_CantPagada      NUMBER(15, 2)  NOT NULL,
    Pre_FechaPago       TIMESTAMP(4),
    CONSTRAINT pk_Cliente_ID_Cod_tipo_pretamo PRIMARY KEY (Pre_Cli_ID, Pre_Cod_tipo_prestamo),
    CONSTRAINT fk_Cliente_ID FOREIGN KEY (Pre_Cli_ID) REFERENCES Cliente (Cli_ID),
    CONSTRAINT fk_Pre_Cod_tipo_prestamo FOREIGN KEY (Pre_Cod_tipo_prestamo) REFERENCES Type_Prestamo (TyPre_Codigo_tipo_Prestamo),
    CONSTRAINT u_Pre_NPrestamos UNIQUE (Pre_NPrestamos)
    );

--2.1 Tabla de muchos a muchos generada entre Sucursales y sus tipos de prestamo
 --O11
 CREATE TABLE Suc_TipoPrest(
    ST_Suc_Cod NUMBER NOT NULL,
    ST_TipoPrest_Cod NUMBER NOT NULL,
    ST_Monto NUMBER(15, 2) NOT NULL,
    CONSTRAINT pk_Suc_Cod_TipoPrest_Cod PRIMARY KEY (ST_Suc_Cod, ST_TipoPrest_Cod),
    CONSTRAINT fk_Suc_Cod FOREIGN KEY (ST_Suc_Cod) REFERENCES Sucursal (Suc_Cod),
    CONSTRAINT fk_TipoPrest_Cod FOREIGN KEY (ST_TipoPrest_Cod) REFERENCES Type_Prestamo (TyPre_Codigo_tipo_Prestamo)
 );

--2. CREACION DE LA TABLA SUCURSAL 
--O10
CREATE TABLE Sucursal (
    Suc_Cod NUMBER  NOT NULL,
    Suc_Nombre VARCHAR2(50) NOT NULL,
    Suc_MontoPrestamo NUMBER(15, 2) NOT NULL,
    CONSTRAINT pk_Suc_Cod PRIMARY KEY (Suc_Cod)
);

--O12
--5. Agregar una tabla transaccional para recibir los pagos de los clientes
--5.1 Secuencias para IDCLIENTE, NUMPRESTAMO, IDTRANSACCION (Se usa en la insercion procedimental)
--SEQUENCE para id_cliente
CREATE SEQUENCE Seq_idCliente
MINVALUE 1
START WITH 1
INCREMENT BY 1;

--SEQUENCE para numero de prestamos
CREATE SEQUENCE Seq_NPrestamos
MINVALUE 1
START WITH 1
INCREMENT BY 1;

--SEQUENCE para id_transaccion
CREATE SEQUENCE Seq_IDTransaction
MINVALUE 1
START WITH 1
INCREMENT BY 1;

--O13
-- Creación de la tabla TransacPagos
CREATE TABLE Transacpagos (
    cod_sucursal        NUMBER NOT NULL,
    id_transaction      NUMBER NOT NULL,
    id_cliente          NUMBER NOT NULL,
    tipoprestamo        VARCHAR2(25) NOT NULL,
    fechatransaction    TIMESTAMP(4) NOT NULL, 
    monto_del_pago      NUMBER(15, 2) NOT NULL, 
    estado              CHAR NOT NULL,
    fechainsercion      TIMESTAMP(4),
    usuario             VARCHAR2(30) NOT NULL,
    CONSTRAINT pk_idtransaccion PRIMARY KEY (id_transaction),
    CONSTRAINT pk_codSucursal FOREIGN KEY (cod_sucursal) REFERENCES Sucursal (Suc_Cod), 
    CONSTRAINT pk_idcliente FOREIGN KEY (id_cliente) REFERENCES Cliente (Cli_ID),
    CONSTRAINT c_estado CHECK (estado in ('A','P'))
    --Los estados para el prestamo son A: Activo, P:Pagado totalmente
);

--FINAL DEL MODELO FISICO

--PROCEDIMIENTOS ALMACENADOS Para la carga de las tablas parametricas (informacion establecida no modificable)
--O14
--1. tipo de telefonos Type_Telefono
CREATE OR REPLACE PROCEDURE AddNewType_Telefono (
    p_Tel_Codigo_tipo_Telefono Type_Telefono.Tel_Codigo_tipo_Telefono%TYPE,
    p_Tel_Desc_Typetelefono Type_Telefono.Tel_Desc_Typetelefono%TYPE,
    p_Mensaje OUT VARCHAR
) AS
BEGIN
--Inserta un nuevo tipo de telefono
INSERT INTO Type_Telefono (Tel_Codigo_tipo_Telefono, Tel_Desc_Typetelefono)
VALUES (p_Tel_Codigo_tipo_Telefono, p_Tel_Desc_Typetelefono);
p_Mensaje := 'Se ha insertado un nuevo tipo de telefono';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewType_Telefono;
/

--O15
--Invocacion AddNewType_Telefono
DECLARE
v_NewCod_tipo_Telefono Type_Telefono.Tel_Codigo_tipo_Telefono%TYPE := &Codigo;
v_New_Tel_Desc_Typetelefono Type_Telefono.Tel_Desc_Typetelefono%TYPE := '&Description';
v_Mensaje VARCHAR2(50);

BEGIN

AddNewType_Telefono(v_NewCod_tipo_Telefono, v_New_Tel_Desc_Typetelefono, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O17
--2. Tipo de correos Type_Email
CREATE OR REPLACE PROCEDURE AddNewType_Email (
    p_Ema_Codigo_tipo_Email Type_Email.Ema_Codigo_tipo_Email%TYPE,
    P_Ema_Desc_TypeEmail Type_Email.Ema_Desc_TypeEmail%TYPE,
    p_Mensaje OUT VARCHAR
) AS
BEGIN
--Inserta un nuevo tipo de email
INSERT INTO Type_Email (Ema_Codigo_tipo_Email, Ema_Desc_TypeEmail)
VALUES (p_Ema_Codigo_tipo_Email, P_Ema_Desc_TypeEmail);
p_Mensaje := 'Se ha insertado un nuevo tipo de Email';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewType_Email;
/

--O18
--Invocacion de AddNewType_Email 
DECLARE
v_NewCod_tipo_Email Type_Email.Ema_Codigo_tipo_Email%TYPE := &Codigo;
v_New_Ema_Desc_TypeEmail Type_Email.Ema_Desc_TypeEmail%TYPE := '&Description';
v_Mensaje VARCHAR2(50);

BEGIN

AddNewType_Email(v_NewCod_tipo_Email, v_New_Ema_Desc_TypeEmail, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O19
--3. Procedimiento para Profesion
CREATE OR REPLACE PROCEDURE AddNewProfesion (
    p_Pro_Cod_Profesion Profesion.Pro_Cod_Profesion%TYPE,
    p_Pro_Desc_Tprof Profesion.Pro_Desc_Tprof%TYPE,
    p_Mensaje OUT VARCHAR
) AS
BEGIN
--Inserta una nueva profesion
INSERT INTO Profesion (Pro_Cod_Profesion, Pro_Desc_Tprof)
VALUES (p_Pro_Cod_Profesion, p_Pro_Desc_Tprof);
p_Mensaje := 'Se ha insertado una nueva Profesion';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewProfesion;
/

--O20
--Invocacion de AddNewProfesion
DECLARE 
v_NewCod_Profesion Profesion.Pro_Cod_Profesion%TYPE := &Codigo;
v_NewDesc_Tprof Profesion.Pro_Desc_Tprof%TYPE := '&Description';
v_Mensaje VARCHAR2(50);

BEGIN

AddNewProfesion(v_NewCod_Profesion, v_NewDesc_Tprof, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O21
--Procedimiento para cargar sucursales
CREATE OR REPLACE PROCEDURE AddNewSucursal (
    p_Suc_Cod Sucursal.Suc_Cod%TYPE,
    p_Suc_Nombre Sucursal.Suc_Nombre%TYPE,
    p_Suc_MontoPrestamo Sucursal.Suc_MontoPrestamo%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
--Inserta una nueva sucursal
INSERT INTO Sucursal(Suc_Cod, Suc_Nombre, Suc_MontoPrestamo)
VALUES (p_Suc_Cod, p_Suc_Nombre, p_Suc_MontoPrestamo);
p_Mensaje := 'Se ha insertado una nueva Sucursal';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewSucursal;
/

--O22
--Invocacion de AddNewSucursal
DECLARE
v_Suc_Cod Sucursal.Suc_Cod%TYPE := &Codigo;
v_Suc_Nombre Sucursal.Suc_Nombre%TYPE := '&NombreSucursal';
v_Suc_MontoPrestamo Sucursal.Suc_MontoPrestamo%TYPE := 0;
v_Mensaje VARCHAR2(50);

BEGIN

AddNewSucursal(v_Suc_Cod, v_Suc_Nombre, v_Suc_MontoPrestamo, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O23
CREATE OR REPLACE PROCEDURE AddNewType_Prestamo(
    p_Codigo_tipo_Prestamo Type_Prestamo.TyPre_Codigo_tipo_Prestamo%TYPE,
    p_Desc_TypePrestamo Type_Prestamo.TyPre_Desc_TypePrestamo%TYPE,
    p_Tasa Type_Prestamo.TyPre_Tasa%TYPE,
    p_Mensaje OUT VARCHAR
) AS
BEGIN
--Inserta un nuevo tipo de prestamo
INSERT INTO Type_Prestamo (TyPre_Codigo_tipo_Prestamo, TyPre_Desc_TypePrestamo, TyPre_Tasa)
VALUES (p_Codigo_tipo_Prestamo, p_Desc_TypePrestamo, p_Tasa);
p_Mensaje := 'Se ha insertado un nuevo tipo de Prestamo';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewType_Prestamo;
/

--O24
--Invocacion de AddNewType_Prestamo
DECLARE
v_Codigo_tipo_Prestamo Type_Prestamo.TyPre_Codigo_tipo_Prestamo%TYPE := &Codigo;
v_Desc_TypePrestamo Type_Prestamo.TyPre_Desc_TypePrestamo%TYPE := '&Description';
v_Tasa Type_Prestamo.TyPre_Tasa%TYPE := &Tasa;
v_Mensaje VARCHAR2(50);

BEGIN

AddNewType_Prestamo(v_Codigo_tipo_Prestamo, v_Desc_TypePrestamo, v_Tasa, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O25
--Procedimiento almacenado para la carga de clientes *Funcion para calcular la edad de los clientes
CREATE OR REPLACE PROCEDURE AddNewClient (
    p_Cedula Cliente.Cli_Cedula%TYPE,
    p_Nombre Cliente.Cli_Nombre%TYPE,
    p_Apellido Cliente.Cli_Apellido%TYPE,
    p_Sexo  Cliente.Cli_Sexo%TYPE,
    p_Nacimiento Cliente.Cli_Nacimiento%TYPE,
    p_Cod_Profesion Cliente.Cli_Cod_Profesion%TYPE,
    p_Edad Cliente.Cli_Edad%TYPE,
    p_SucCod Cliente.Cli_Suc_Cod%TYPE,
    p_Mensaje OUT VARCHAR2

) AS
BEGIN

INSERT INTO CLiente (Cli_ID, Cli_Cedula, Cli_Nombre, Cli_Apellido, Cli_Sexo, Cli_Nacimiento, Cli_Cod_Profesion, Cli_Edad, Cli_Suc_Cod)
VALUES (Seq_idCliente.NextVal, p_Cedula, p_Nombre, p_Apellido, p_Sexo, p_Nacimiento, p_Cod_Profesion, p_Edad, p_SucCod);

p_Mensaje := 'Se ha insertado un nuevo cliente';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewClient;
/

--O26
--FUNCION calc_Edad
CREATE OR REPLACE FUNCTION calc_Edad (
    p_fechanacim Cliente.Cli_Nacimiento%TYPE)
    RETURN NUMBER AS
    BEGIN
    RETURN FLOOR(months_between(sysdate, p_fechanacim)/12);
    END calc_Edad;
    /

--O27
--invocacion de AddNewClient
DECLARE
v_newCedula Cliente.Cli_Cedula%TYPE := '&Cedula';
v_newName Cliente.Cli_Nombre%TYPE := '&NombreCliente';
v_newApellido Cliente.Cli_Apellido%TYPE := '&ApellidoCliente';
v_newSexo Cliente.Cli_Sexo%TYPE := '&Sexo';
v_newNacimiento Cliente.Cli_Nacimiento%TYPE := '&FechaNacimiento';
v_newCodProf Cliente.Cli_Cod_Profesion%TYPE := &CodigoDeProfesion;
v_newEdad Cliente.Cli_Edad%TYPE;
v_newCodSuc Cliente.Cli_Suc_Cod%TYPE := &CodigoSucursal;
v_Mensaje VARCHAR2(50);

BEGIN
v_newEdad := calc_Edad(v_newNacimiento);

AddNewClient(v_newCedula, v_newName, v_newApellido, v_newSexo, v_newNacimiento, v_newCodProf,
v_newEdad, v_newCodSuc, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--inv cliente 
DECLARE
v_newNacimiento Cliente.Cli_Nacimiento%TYPE := '&FechaNacimiento';
v_newEdad Cliente.Cli_Edad%TYPE;
v_Mensaje VARCHAR2(50);

BEGIN
v_newEdad := calc_Edad(v_newNacimiento);
AddNewClient('8-988-765', 'Pep', 'Guardiola', 'M', v_newNacimiento, 01,
v_newEdad, 01, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--O28
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
v_SucMonto sucursal.Suc_MontoPrestamo%TYPE;
v_Saldoact Prestamo.Pre_Saldo_Actual%TYPE;
v_SucTipoMonto Suc_TipoPrest.ST_Monto%TYPE;
v_sucCodtipoPre Suc_TipoPrest.ST_TipoPrest_Cod%TYPE;

BEGIN

INSERT INTO Prestamo(Pre_Cli_ID, Pre_Cod_tipo_prestamo, Pre_NPrestamos, Pre_Fecha_Apro, Pre_CantAprobada, Pre_LetraMensual, 
Pre_CantPagada, Pre_FechaPago, Pre_Suc_Cod, Pre_Saldo_Actual, Pre_Interes_Pagado, Pre_Fecha_Mod, Pre_Usuario)
VALUES(p_Pre_Cli_ID, p_Pre_Cod_tipo_prestamo, Seq_NPrestamos.NextVal, current_timestamp, p_Pre_CantAprobada, p_Pre_LetraMensual, 
0, p_Pre_FechaPago, p_Pre_Suc_Cod, p_Pre_Saldo_Actual, 0,  p_Pre_Fecha_Mod, User);

--seleccionar la informacion que se inserto en la tabla sucursal con el procedimiento
SELECT Suc_MontoPrestamo INTO v_SucMonto
FROM Sucursal 
WHERE Suc_Cod = p_Pre_Suc_Cod;
v_SucMonto := v_SucMonto + p_Pre_CantAprobada;

--actualizar monto de la sucursal
UPDATE Sucursal SET 
Suc_MontoPrestamo = v_SucMonto
WHERE Suc_Cod = p_Pre_Suc_Cod;

/*seleccionar la informacion que se encuentre en la tabla Suc_TipoPrest para poder actualizarla
si esta informacion no existe entonces se inserta*/
SELECT ST_Monto INTO v_SucTipoMonto
FROM Suc_TipoPrest
WHERE ST_Suc_Cod = p_Pre_Suc_Cod
AND ST_TipoPrest_Cod = p_Pre_Cod_tipo_prestamo;
v_SucTipoMonto :=  v_SucTipoMonto + p_Pre_CantAprobada;

/*Validar si en suc tipo pres existe la sucursal y el tipo de prestamo que se acaba de insertar,
si no existe se debe insertar y si existe se debe actualizar*/

UPDATE Suc_TipoPrest SET
ST_Monto = v_SucTipoMonto
WHERE ST_Suc_Cod = p_Pre_Suc_Cod
AND ST_TipoPrest_Cod = p_Pre_Cod_tipo_prestamo;

p_Mensaje := 'Operaciones completadas';

EXCEPTION
WHEN NO_DATA_FOUND THEN
INSERT INTO Suc_TipoPrest(ST_Suc_Cod, ST_TipoPrest_Cod, ST_Monto)
VALUES (p_Pre_Suc_Cod, p_Pre_Cod_tipo_prestamo, p_Pre_CantAprobada);
p_Mensaje := 'Operaciones completadas';

WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);
--p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewPrestamo;
/
--o29
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

--O30
--Procedimiento almacenado para la carga de los pagos de clientes en Transacpagos
CREATE OR REPLACE PROCEDURE AddNewPago(

    p_CodSucursal Transacpagos.cod_sucursal%TYPE,
    p_id_cliente Transacpagos.id_cliente%TYPE,
    p_tipoprestamo Transacpagos.tipoprestamo%TYPE,
    p_montoPago Transacpagos.monto_del_pago%TYPE,
    p_estado Transacpagos.estado%TYPE,
    p_Mensaje OUT VARCHAR2

) AS
BEGIN

INSERT INTO Transacpagos(cod_sucursal, id_transaction, id_cliente, tipoprestamo, fechatransaction, monto_del_pago, estado, fechainsercion, usuario)
VALUES(p_CodSucursal, Seq_IDTransaction.NextVal, p_id_cliente, p_tipoprestamo, current_timestamp, p_montoPago, p_estado, NULL, User);
p_Mensaje := 'Se ha realizado un nuevo pago';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END AddNewPago;
/

--O31
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

--O32
--Funcion calc_Int
CREATE OR REPLACE FUNCTION calc_Int(
    p_Saldo_Actual Prestamo.Pre_Saldo_Actual%TYPE,
    p_LetraMensual Prestamo.Pre_LetraMensual%TYPE
) RETURN NUMBER AS
BEGIN
--Se calcula el interes del prestamo
RETURN p_Saldo_Actual * (p_LetraMensual/100);
END calc_Int;
/

--O33
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
--variable para tomar el monto de la tabla sucursal
v_SucMonto sucursal.Suc_MontoPrestamo%TYPE;
--Variable para actualizar monto en sucursal
v_SucActMont Sucursal.Suc_MontoPrestamo%TYPE;

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

/*Para actualizar el monto de la tabla SUCURSAL a medida que de vayan insertandopagos,
se van restando del total que se debe en la sucursal*/
SELECT Suc_MontoPrestamo INTO v_SucMonto
FROM Sucursal
WHERE Suc_Cod = v_counterpay.cod_sucursal;

--Monto de sucursal calculado 
v_SucActMont := v_SucMonto - v_cantpCalc;

UPDATE Sucursal SET
Suc_MontoPrestamo = v_SucActMont
WHERE Suc_Cod = v_counterpay.cod_sucursal;

/*Para actualiza el monto de la tabla SUC_TIPOPREST a medida que se vayan insertando pagos de un tipo de prestamo en la sucursal
en la que fueron prestados*/
SELECT ST_Monto INTO v_SucMonto
FROM Suc_TipoPrest
WHERE ST_Suc_Cod = v_counterpay.cod_sucursal
AND ST_TipoPrest_Cod = v_counterpay.tipoprestamo;

--Monto de Suc_TipoPrest
v_SucActMont := v_SucMonto - v_cantpCalc;

UPDATE Suc_TipoPrest SET 
ST_Monto = v_SucActMont
WHERE ST_Suc_Cod = v_counterpay.cod_sucursal
AND ST_TipoPrest_Cod = v_counterpay.tipoprestamo;

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

--O34
DECLARE
v_mensaje varchar2(50);
BEGIN
ActPrestamo(v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_mensaje);
END;
/





