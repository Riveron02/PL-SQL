--LABORATORIO 3

--SEQUENCE para id estudiante
CREATE SEQUENCE Seq_Est_id
MINVALUE 1
MAXVALUE 999999999
START WITH 1
INCREMENT BY 1;

--Implemente el modelo fisico
--TABLA DE ESTUDIANTE
CREATE TABLE Estudiante(Est_id NUMBER PRIMARY KEY NOT NULL,
Est_Nombre VARCHAR2(50) NOT NULL,
Est_Apellido VARCHAR2(50) NOT NULL,
Est_Cedula VARCHAR2(20) NOT NULL,
CONSTRAINT u_cedulaEst UNIQUE (Est_Cedula)
);

--TABLA DE MATERIAS
CREATE TABLE Materia(Mat_id NUMBER PRIMARY KEY NOT NULL,
Mat_Nombre VARCHAR2(50) NOT NULL
);

--RELACION MUCHOS A MUCHOS(TABLA CALIFICACIONES)
CREATE TABLE Calificaciones(Ca_Est_id NUMBER NOT NULL,
Ca_Mat_id NUMBER NOT NULL,
Ca_Nota_Num NUMBER NOT NULL,
Ca_Nota_Alf CHAR(1) NULL,
PRIMARY KEY (Ca_Est_id, Ca_Mat_id), 
CONSTRAINT Estudiante_id FOREIGN KEY (Ca_Est_id) REFERENCES Estudiante (Est_id), 
CONSTRAINT Materia_id FOREIGN KEY (Ca_Mat_id) REFERENCES Materia (Mat_id),
CONSTRAINT c_NotaNum CHECK (ca_Nota_Num BETWEEN 0 and 100)
);




--Procedimientos para insercion
--1. Para estudiantes
--p en nombre de la variable es para parametro
CREATE OR REPLACE PROCEDURE AddNewStudent (
p_EstName Estudiante.Est_Nombre%TYPE,
p_EstLastName Estudiante.Est_Apellido%TYPE,
p_EstCedula Estudiante.Est_Cedula%TYPE,
p_Mensaje OUT VARCHAR2

) AS 
BEGIN
--Inserta un nuevo estudiante
INSERT INTO Estudiante (Est_id, Est_Nombre, Est_Apellido, Est_Cedula)
VALUES (Seq_Est_id.NextVal, p_EstName, p_EstLastName, p_EstCedula);
p_Mensaje := 'Se ha insertado un nuevo estudiante';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END;
/

--2. Para Materias
CREATE OR REPLACE PROCEDURE AddNewMateria (

p_MateriaID Materia.Mat_id%TYPE,
p_MatNombre Materia.Mat_Nombre%TYPE,
p_Mensaje OUT VARCHAR2

) AS
BEGIN
--Inserta una nueva materia
INSERT INTO Materia (Mat_id, Mat_Nombre)
VALUES (p_MateriaID, p_MatNombre);

p_Mensaje := 'Se ha insertado un nueva materia';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';
COMMIT;
END;
/

--3. Para Calificaciones
CREATE OR REPLACE PROCEDURE AddNewNota (
p_CaEst_id Calificaciones.Ca_Est_id%TYPE,
p_CaMat_id Calificaciones.Ca_Mat_id%TYPE,
p_CaNotaNum Calificaciones.Ca_Nota_Num%TYPE,
p_Mensaje OUT VARCHAR2
) AS
BEGIN
--Inserta una nueva nota
INSERT INTO Calificaciones (Ca_Est_id, Ca_Mat_id, Ca_Nota_Num)
VALUES (p_CaEst_id, p_CaMat_id, p_CaNotaNum);

p_Mensaje := 'Se ha insertado una nueva calificacion';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'LOS REGISTROS NO PUEDEN DUPLICARSE';
WHEN OTHERS THEN
p_Mensaje := 'Error...NO SE PUDO COMPLETAR LA OPERACION';

COMMIT;
END;
/



DECLARE
v_NewEstName Estudiante.Est_Nombre%TYPE := '&Nombre';
v_NewLastName Estudiante.Est_Apellido%TYPE := '&Apellido';
v_NewEstCed Estudiante.Est_Cedula%TYPE := '&cedula';
v_Mensaje VARCHAR2(50);
BEGIN
AddNewStudent(v_NewEstName, v_NewLastName, v_NewEstCed, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--EXCEPTION
--WHEN DUP_VAL_ON_INDEX THEN
--DBMS_OUTPUT.PUT_LINE('LOS REGISTROS NO PUEDEN DUPLICARSE');

--AddNewMateria(1, 'Base de Datos');
--AddNewMateria(2, 'Ingenieria de Software');
--AddNewMateria(3, 'Formacion de Emprendedores');


DECLARE

v_IdMat Materia.Mat_id%TYPE := &idMATERIA;
v_NewMatName Materia.Mat_Nombre%TYPE := '&NombreMateria';
v_Mensaje VARCHAR2(50);

BEGIN
--2. INVOCACION DEL PROCESO AddNewMateria
AddNewMateria(v_IdMat, v_NewMatName, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/


DECLARE
v_idEst Estudiante.Est_id%TYPE := &IDESTUDIANTE;
v_idMat Materia.Mat_id%TYPE := &IDMATERIA;
v_NotaNum Calificaciones.Ca_Nota_Num%TYPE := &NOTANUMERICA;
v_Mensaje VARCHAR2(50);

BEGIN
--3. INVOCACION DEL PROCEDIMIENTO AddNewCalificacion
AddNewNota(v_idEst, v_idMat, v_NotaNum, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/


DECLARE
v_alphabetical Calificaciones.Ca_Nota_Alf%TYPE;

CURSOR c_calificacion IS
SELECT Ca_Nota_Num, Ca_Nota_Alf, Ca_Mat_id, Ca_Est_id FROM
Calificaciones
WHERE Ca_Mat_id = 1;

BEGIN
FOR v_counterCalif IN c_calificacion LOOP

IF v_counterCalif.Ca_Nota_Num >= 91 THEN
v_alphabetical := 'A';

ELSIF v_counterCalif.Ca_Nota_Num >= 81 THEN
v_alphabetical := 'B'; 

ELSIF v_counterCalif.Ca_Nota_Num >= 71 THEN
v_alphabetical := 'C';

ELSIF v_counterCalif.Ca_Nota_Num >= 61 THEN
v_alphabetical := 'D';

ELSE
v_alphabetical := 'F';
END IF;
UPDATE Calificaciones SET Ca_Nota_Alf = v_alphabetical
WHERE v_counterCalif.Ca_Est_id = Calificaciones.Ca_Est_id;
END LOOP;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('NO EXISTE INFORMACION REQUERIDA');
COMMIT;
END;
/

CREATE VIEW Calificacion_Estudiante AS
SELECT (e.Est_Nombre || '' || e.Est_Apellido) Nombre_Estudiante,
m.Mat_Nombre Materia, c.Ca_Nota_Num Nota_Numerica, c.Ca_Nota_Alf Resultado_Alfabetico
FROM Calificaciones c
JOIN Estudiante e ON e.Est_ID = c.Ca_Est_id
JOIN Materia m ON m.Mat_id = c.Ca_Mat_id
GROUP BY (e.Est_Nombre || '' || e.Est_Apellido), m.Mat_Nombre, c.Ca_Nota_Num, c.Ca_Nota_Alf;

