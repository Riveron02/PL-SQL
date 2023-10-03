
set serveroutput on;

-- Creación de tabla de Colaboradores

CREATE TABLE colaboradores (
	id_codcolaborador NUMBER not null,
	nombre VARCHAR2(25) not null,
	apellido VARCHAR2(25) not null,
	cedula VARCHAR2(12) not null,
	sexo CHAR not null,
	fecha_nacimiento DATE not null,
	fecha_ingreso DATE not null,
	status CHAR not null,
	salario_mensual NUMBER(15,2),
	CONSTRAINT pk_codColaborador PRIMARY KEY (id_codcolaborador),
	CONSTRAINT c_sexocolab CHECK (sexo in ('M','F')),
	CONSTRAINT c_status CHECK (status in ('A', 'V', 'R')),
	CONSTRAINT u_cedula UNIQUE (cedula)
);


-- Creación de la tabla Salario Quincenal
CREATE TABLE salario_quincenal (
	id_salario NUMBER not null,
	id_codcolaborador NUMBER not null,
	fecha_pago DATE not null,
	salario_quincena NUMBER(15,2),
	seguro_social NUMBER(15,2),
	seguro_educativo NUMBER(15,2),
	salario_neto NUMBER(15,2),
	CONSTRAINT pk_idSalario PRIMARY KEY (id_salario),
	CONSTRAINT fk_codColaborador FOREIGN KEY (id_codcolaborador) REFERENCES colaboradores (id_codcolaborador)
);


-- Creación de la secuencia para los ID de los Colaboradores
CREATE SEQUENCE sec_idColaboradores
START WITH 1
INCREMENT BY 1
MINVALUE 1;


-- Creación de la secuencia para los ID de los Salarios 

CREATE SEQUENCE sec_salarios
START WITH 1
INCREMENT BY 1
MINVALUE 1;

-- Creación de la vista requerida

CREATE VIEW Vista_SalariosQuincenales AS 
SELECT
c.id_codcolaborador "Codigo",
c.nombre "Nombre",
c.apellido "Apellido",
c.salario_mensual "Salario Mensual",
sq.salario_quincena "Salario Quincenal",
sq.seguro_social "Seguro Social",
sq.seguro_educativo "Seguro Educativo",
sq.salario_neto "Salario Neto"
FROM colaboradores c
JOIN salario_quincenal sq 
ON c.id_codcolaborador = sq.id_codcolaborador
WHERE status = 'A'
ORDER BY c.id_codcolaborador ASC;

_____________________________________________________________________________

-- Creación del Procedimiento para la Inserción de los Colaboradores

CREATE OR REPLACE PROCEDURE addNewColab (
	p_nombreColab colaboradores.nombre%TYPE,
	p_apellidoColab colaboradores.apellido%TYPE,
	p_cedulaColab colaboradores.cedula%TYPE,
	p_sexoColab colaboradores.sexo%TYPE,
	p_fechaNac_Colab colaboradores.fecha_nacimiento%TYPE,
	p_fechaIng_Colab colaboradores.fecha_ingreso%TYPE,
	p_statusColab colaboradores.status%TYPE,
	p_salarioMensColab colaboradores.salario_mensual%TYPE,
	p_Mensaje OUT VARCHAR2

) AS
BEGIN

INSERT INTO colaboradores (id_codcolaborador, nombre, apellido, cedula, sexo, fecha_nacimiento, fecha_ingreso, status, salario_mensual)
VALUES (sec_idColaboradores.NextVal, p_nombreColab, p_apellidoColab, p_cedulaColab,
p_sexoColab, p_fechaNac_Colab, p_fechaIng_Colab, p_statusColab, p_salarioMensColab);

p_Mensaje := 'Se ha insertado un nuevo colaborador';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END addNewColab;
/


--1. Invocacion del procedimiento addNewColab
--Inserción de Datos en el procedimiento addNewColab 

DECLARE

	v_newNombreColab colaboradores.nombre%TYPE := '&Nombre';
	v_newApellidoColab colaboradores.apellido%TYPE := '&Apellido';
	v_newCedulaColab colaboradores.cedula%TYPE := '&Cedula';
	v_newSexoColab colaboradores.sexo%TYPE := '&Sexo';
	v_newFechaNacColab colaboradores.fecha_nacimiento%TYPE := '&FechaNacimiento';
	v_newFechaIngColab colaboradores.fecha_ingreso%TYPE:= '&FechaIngreso';
	v_newStatusColab colaboradores.status%TYPE:= '&EstatusActual';
	v_newSalarioMensColab colaboradores.salario_mensual%TYPE:= &SalarioMensual;
	v_Mensaje VARCHAR2(50);

BEGIN

addNewColab(v_newNombreColab,v_newApellidoColab,v_newCedulaColab, v_newSexoColab,
v_newFechaNacColab, v_newFechaIngColab, v_newStatusColab, v_newSalarioMensColab, v_Mensaje);

DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END addNewColab;
/

--2. Creacion del preocedimiento para insertar salarios
CREATE OR REPLACE PROCEDURE addNewSalario (
    p_codcolaborador colaboradores.id_codcolaborador%TYPE,
	p_salarioMensual colaboradores.salario_mensual%TYPE,
	p_Mensaje OUT VARCHAR2

) AS
    v_salario_quincenal salario_quincenal.salario_quincena%TYPE;
    v_seguro_social salario_quincenal.seguro_social%TYPE;
    v_seguro_educativo salario_quincenal.seguro_educativo%TYPE;
    v_salario_neto salario_quincenal.salario_neto%TYPE;

BEGIN

--llamado a las funciones que calculan los salarios con el salario mensual y quincenal
v_salario_quincenal := FUN_Salario_Quincenal(p_salarioMensual);
v_seguro_social := FUN_Seguro_Social(v_salario_quincenal);
v_seguro_educativo := FUN_Seguro_Educativo(v_salario_quincenal);
v_salario_neto := FUN_Salario_Neto(v_salario_quincenal, v_seguro_social, v_seguro_educativo);

INSERT INTO salario_quincenal (id_salario, id_codcolaborador, fecha_pago, salario_quincena, seguro_social, seguro_educativo, salario_neto)
VALUES (sec_salarios.NextVal, p_codcolaborador, SYSDATE, v_salario_quincenal, v_seguro_social, v_seguro_educativo, v_salario_neto);
p_Mensaje := 'Se ha insertado un nuevo salario';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END addNewSalario;
/

--1. funcion que calcula el salario quincenal
CREATE OR REPLACE FUNCTION FUN_Salario_Quincenal(
	p_salMensual colaboradores.salario_mensual%TYPE)
	RETURN NUMBER AS
	BEGIN
	RETURN p_salMensual / 2;
	End FUN_Salario_Quincenal;
/
--2. funcion que calcula el seguro social
CREATE OR REPLACE FUNCTION FUN_Seguro_Social(
	p_salQuincenal salario_quincenal.salario_quincena%TYPE)
RETURN NUMBER AS
BEGIN
RETURN P_salQuincenal * 0.0975;
End FUN_Seguro_Social;
/
--funcion que calcula el seguro educativo
CREATE OR REPLACE FUNCTION FUN_Seguro_Educativo(
	p_salQuincenal salario_quincenal.salario_quincena%TYPE)
RETURN NUMBER AS
BEGIN
RETURN P_salQuincenal * 0.0125;
End FUN_Seguro_Educativo;
/
--funcion que calcula el salario neto
CREATE OR REPLACE FUNCTION FUN_Salario_Neto(
	p_salQuincenal salario_quincenal.salario_quincena%TYPE,
	p_segSocial salario_quincenal.seguro_social%TYPE,
	p_segEducativo salario_quincenal.seguro_educativo%TYPE)
RETURN NUMBER AS
BEGIN
RETURN p_salQuincenal - p_segSocial - p_segEducativo;
End FUN_Salario_Neto;
/

--3. Implementacion del cursor de busqueda
DECLARE
	v_Mensaje VARCHAR2(50);


CURSOR c_colaboradores IS
SELECT id_codcolaborador, salario_mensual FROM colaboradores
WHERE status = 'A';

BEGIN
--Las fechas de pago son los 15 y 30 de cada mes
IF TO_CHAR(SYSDATE, 'DD') = '24' OR TO_CHAR(SYSDATE, 'DD') = '30' THEN
FOR v_counterColab IN c_colaboradores LOOP

--llamda al procedimiento con los valores buscados por el cursor
addNewSalario(v_counterColab.id_codcolaborador, v_counterColab.salario_mensual, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END LOOP;
END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('NO EXISTE LA INFORMACION REQUERIDA');
END;
/
/*EXCEPTION WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('NO EXISTE INFORMACION REQUERIDA');*/
