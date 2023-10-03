
-- PROYECTO FINAL BD2 HELEN RIVERON ---  

-- set serveroutput on
-- set linesize 300
-- alter session set nls_date_format = 'DD-MM-YYYY'; // SOLO SI ES NECESARIO, AJUSTEN EL FORMATO AL FORMATO DE SUS DISPOSITIVOS.



-- MODELO FÍSICO ___________________________________________________________________________


CREATE TABLE Sucursales (
    Suc_ID      NUMBER      NOT NULL,
    Suc_Name    VARCHAR(50) NOT NULL,
    Suc_DirecID NUMBER      NOT NULL,
    CONSTRAINT pk_Suc_ID        PRIMARY KEY (Suc_ID),
    CONSTRAINT fk_Suc_DirecID   FOREIGN KEY (Suc_DirecID) REFERENCES Direccion_Suc (Dir_ID)
);


CREATE TABLE Direccion_Suc (
    Dir_ID          NUMBER      NOT NULL,
    Dir_Provincia   VARCHAR(25) NOT NULL,
    Dir_Distrito    VARCHAR(25) NOT NULL,
    CONSTRAINT pk_Dir_ID PRIMARY KEY (Dir_ID)
);


CREATE TABLE Telefonos_Suc (
    TelS_TypeID     NUMBER NOT NULL,
    TelS_SucursalID NUMBER NOT NULL,
    TelS_Number     NUMBER NOT NULL,
    CONSTRAINT pk_TypeID_SucursalID PRIMARY KEY (TelS_TypeID, TelS_SucursalID),
    CONSTRAINT fk_TelS_TypeID       FOREIGN KEY (TelS_TypeID)       REFERENCES Type_Telefonos (Type_ID),
    CONSTRAINT fk_TelS_SucursalID   FOREIGN KEY (TelS_SucursalID)   REFERENCES Sucursales (Suc_ID) 
);


CREATE TABLE Email_Suc (
    EmS_TypeID      NUMBER      NOT NULL,
    EmS_SucursalID  NUMBER      NOT NULL,
    EmS_Direccion   VARCHAR(50) NOT NULL,
    CONSTRAINT pk_EmS_TypeID_SucursalID PRIMARY KEY (EmS_TypeID, EmS_SucursalID),
    CONSTRAINT fk_EmS_TypeID            FOREIGN KEY (EmS_TypeID)        REFERENCES Type_Email (TypeE_ID),
    CONSTRAINT fk_EmS_SucursalID        FOREIGN KEY (EmS_SucursalID)    REFERENCES Sucursales (Suc_ID)
);


CREATE TABLE ColaboradoresCine (
    Col_ID              NUMBER      NOT NULL,
    Col_Suc_ID          NUMBER      NOT NULL,
    Col_CIP             VARCHAR(25) NOT NULL,
    Col_Name            VARCHAR(25) NOT NULL,
    Col_FirstApellido   VARCHAR(25) NOT NULL,
    Col_SecApellido     VARCHAR(25) NOT NULL,
    Col_Genero          CHAR        NOT NULL,
    Col_FechaNac        DATE        NOT NULL,          
    Col_Edad            NUMBER      NOT NULL,
    CONSTRAINT pk_Col_ID        PRIMARY KEY (Col_ID),
    CONSTRAINT fk_Col_Suc_ID    FOREIGN KEY (Col_Suc_ID) REFERENCES Sucursales (Suc_ID),
    CONSTRAINT u_Col_CIP        UNIQUE (Col_CIP),
    CONSTRAINT c_Col_Genero     CHECK (Col_Genero IN ('M','F')),
    CONSTRAINT c_Col_Edad CHECK (Col_Edad BETWEEN 18 AND 64)
);


CREATE TABLE Telefonos_Colab (
    TelC_TypeID         NUMBER NOT NULL,
    TelC_ColaboradorID  NUMBER NOT NULL,
    TelC_Number         NUMBER NOT NULL,
    CONSTRAINT pk_TypeID_ColaboradorID  PRIMARY KEY (TelC_TypeID, TelC_ColaboradorID),
    CONSTRAINT fk_TelC_TypeID           FOREIGN KEY (TelC_TypeID)           REFERENCES Type_Telefonos (Type_ID),
    CONSTRAINT fk_TelC_ColaboradorID    FOREIGN KEY (TelC_ColaboradorID)    REFERENCES ColaboradoresCine (Col_ID)
);


CREATE TABLE Email_ColaboradoresCine (
    EmC_TypeID          NUMBER      NOT NULL,
    EmC_ColaboradorID   NUMBER      NOT NULL,
    EmC_Direccion       VARCHAR(50) NOT NULL,
    CONSTRAINT pk_Emc_TypeID_ColaboradorID  PRIMARY KEY (Emc_TypeID, EmC_ColaboradorID),
    CONSTRAINT fk_Emc_TypeID                FOREIGN KEY (Emc_TypeID)        REFERENCES Type_Email (TypeE_ID),
    CONSTRAINT fk_Emc_ColaboradorID         FOREIGN KEY (Emc_ColaboradorID) REFERENCES ColaboradoresCine (Col_ID)
);


CREATE TABLE Type_Email (
    TypeE_ID    NUMBER      NOT NULL,
    Descripcion VARCHAR(25) NOT NULL,
    CONSTRAINT pk_TypeE_ID PRIMARY KEY (TypeE_ID)
);


CREATE TABLE Type_Telefonos (
    Type_ID     NUMBER      NOT NULL,
    Descripcion VARCHAR(25) NOT NULL,
    CONSTRAINT pk_Type_ID PRIMARY KEY (Type_ID)
);


CREATE TABLE Boletos (
    Bol_ID          NUMBER  NOT NULL,
    Bol_FechaCreado TIMESTAMP(4)    NOT NULL, 
    Bol_TaquillaID  NUMBER  NOT NULL,
    CONSTRAINT pk_Bol_ID            PRIMARY KEY (Bol_ID),
    CONSTRAINT fk_Bol_TaquillaID    FOREIGN KEY (Bol_TaquillaID) REFERENCES Taquillas (Taq_ID)
);



CREATE TABLE Taquillas (
    Taq_ID      NUMBER NOT NULL,
    Taq_Tipo_Boleto VARCHAR2(20) NOT NULL,
    Precio          NUMBER(15, 2) NOT NULL,
    CONSTRAINT pk_Taq_ID PRIMARY KEY (Taq_ID)
);


CREATE TABLE Platillos (
    Pla_ID      NUMBER      NOT NULL,
    Pla_Name    VARCHAR(50) NOT NULL,
    Pla_Precio  NUMBER(15, 2)      NOT NULL,
    CONSTRAINT pk_Pla_ID PRIMARY KEY (Pla_ID)
);


CREATE TABLE Salas (
    Sal_ID          NUMBER NOT NULL,
    Sal_SucursalID  NUMBER NOT NULL,
    Sal_Tipo_SalaID  NUMBER NOT NULL,
    Sal_PeliculaID  NUMBER NOT NULL,
    CONSTRAINT pk_Sal_ID         PRIMARY KEY (Sal_ID),
    CONSTRAINT fk_Sal_SucursalID FOREIGN KEY (Sal_SucursalID) REFERENCES Sucursales (Suc_ID),
    CONSTRAINT fk_Sal_Tipo_SalaID FOREIGN KEY (Sal_Tipo_SalaID) REFERENCES Tipo_Sala (TypeS_ID),
    CONSTRAINT fk_Sal_PeliculaID FOREIGN KEY (Sal_PeliculaID) REFERENCES Peliculas (Pel_ID)
);


CREATE TABLE Tipo_Sala (
    TypeS_ID                NUMBER      NOT NULL,
    TypeS_Descripcion       VARCHAR(25) NOT NULL,
    TypeS_PrecioAgregado    NUMBER      NOT NULL,
    CONSTRAINT pk_TypeS_ID PRIMARY KEY (TypeS_ID)
);


CREATE TABLE Asientos (
    Asi_ID      NUMBER NOT NULL,
    Asi_Num     NUMBER NOT NULL,
    Asi_SalaID  NUMBER NOT NULL,
    Asi_Fila    CHAR NOT NULL,
    Asi_Estado  CHAR NOT NULL,
    CONSTRAINT pk_Asi_ID_Asi_SalaID PRIMARY KEY (Asi_ID, Asi_SalaID),
    CONSTRAINT fk_Asi_SalaID    FOREIGN KEY (Asi_SalaID) REFERENCES Salas (Sal_ID),
    CONSTRAINT c_Asi_Fila       CHECK (Asi_Fila IN ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J')),
    CONSTRAINT c_Asi_Estado     CHECK (Asi_Estado IN ('D', 'N'))
);


CREATE TABLE Peliculas (
    Pel_ID              NUMBER          NOT NULL,
    Pel_Name            VARCHAR(50)     NOT NULL,
    Pel_Sinopsis        VARCHAR(650)    NOT NULL,
    Pel_TypeGeneroID    NUMBER          NOT NULL,
    Pel_ClasificacionID NUMBER          NOT NULL,
    Pel_Estado          CHAR            NOT NULL,
    CONSTRAINT pk_Pel_ID                PRIMARY KEY (Pel_ID),
    CONSTRAINT fk_Pel_TypeGeneroID      FOREIGN KEY (Pel_TypeGeneroID)      REFERENCES Tipo_Genero (TypeG_ID),
    CONSTRAINT c_Pel_Estado     CHECK (Pel_Estado IN ('D','N')), --Estados D: Disponible, N: No disponible
    CONSTRAINT fk_Pel_ClasificacionID   FOREIGN KEY (Pel_ClasificacionID)   REFERENCES Clasificacion_Peli (Cla_ID)
);


CREATE TABLE Clasificacion_Peli (
    Cla_ID          NUMBER      NOT NULL,
    Cla_Descripcion VARCHAR(25) NOT NULL,
    CONSTRAINT pl_Cla_ID PRIMARY KEY (Cla_ID)
);


CREATE TABLE Factura_Boleto (
    FactB_ID            NUMBER  NOT NULL,
    FactB_Fecha         TIMESTAMP(4)    NOT NULL,           
    FactB_ColaboradorID NUMBER  NOT NULL,
    FactB_Estado        CHAR NOT NULL,
    FactB_FechaProcesada TIMESTAMP(4),
    CONSTRAINT pk_FactB_ID              PRIMARY KEY (FactB_ID),
    CONSTRAINT fk_FactB_ColaboradorID   FOREIGN KEY (FactB_ColaboradorID) REFERENCES ColaboradoresCine (Col_ID),
    CONSTRAINT c_FactB_Estado     CHECK (FactB_Estado IN ('R', 'P')) --R: Registrada P:Procesada
);


CREATE TABLE Factura_Dulceria (
    FactD_ID            NUMBER  NOT NULL,
    FactD_Fecha         TIMESTAMP(4)    NOT NULL,    
    FactD_ColaboradorID NUMBER  NOT NULL,
    FactD_Estado        CHAR NOT NULL,
    FactD_FechaProcesada TIMESTAMP(4),
    CONSTRAINT pk_FactD_ID              PRIMARY KEY (FactD_ID),
    CONSTRAINT fk_FactD_ColaboradorID   FOREIGN KEY (FactD_ColaboradorID) REFERENCES ColaboradoresCine (Col_ID),
    CONSTRAINT c_FactD_Estado     CHECK (FactD_Estado IN ('R', 'P')) --R: Registrada P:Procesada
);


CREATE TABLE Orden_Boleto (
    OrdB_Boleto_ID      NUMBER NOT NULL,
    OrdB_FacturaBol_ID  NUMBER NOT NULL,
    OrdB_Asiento_ID     NUMBER NOT NULL,
    CONSTRAINT pk_Boleto_FacturaBol_Asiento PRIMARY KEY (OrdB_Boleto_ID, OrdB_FacturaBol_ID, OrdB_Asiento_ID),
    CONSTRAINT fk_OrdB_Boleto_ID            FOREIGN KEY (OrdB_Boleto_ID)        REFERENCES Boletos (Bol_ID),
    CONSTRAINT fk_OrdB_FacturaBol_ID        FOREIGN KEY (OrdB_FacturaBol_ID)    REFERENCES Factura_Boleto (FactB_ID),
    CONSTRAINT fk_OrdB_Asiento_ID           FOREIGN KEY (OrdB_Asiento_ID)       REFERENCES Asientos (Asi_ID)
);


CREATE TABLE Orden_Dulceria(
    OrdD_Platillo_ID    NUMBER NOT NULL,
    OrdD_FacturaDul_ID  NUMBER NOT NULL,
    OrdD_CantProductos  NUMBER NOT NULL,
    CONSTRAINT pk_platillo_ID_FacturaDul_ID PRIMARY KEY (OrdD_Platillo_ID, OrdD_FacturaDul_ID),
    CONSTRAINT fk_OrdD_Platillo_ID          FOREIGN KEY (OrdD_Platillo_ID)      REFERENCES Platillos (Pla_ID),
    CONSTRAINT fk_OrdD_FacturaDul_ID        FOREIGN KEY (OrdD_FacturaDul_ID)    REFERENCES Factura_Dulceria (FactD_ID)
);


-- SECUENCIAS ___________________________________________________________________________

CREATE SEQUENCE Seq_ColaboradoresCine
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1;


CREATE SEQUENCE Seq_Boletos
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1;


 CREATE SEQUENCE Seq_Peliculas
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1; 


 CREATE SEQUENCE Seq_Generos
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1;

 CREATE SEQUENCE Seq_Factura_Dulceria
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1; 

 CREATE SEQUENCE Seq_Factura_Boletos
    MINVALUE 1
    START WITH 1
    INCREMENT BY 1;

 CREATE SEQUENCE tri_AudiFacturas
    START WITH 1
    INCREMENT BY 1;

 CREATE SEQUENCE tri_AudiOrdenes
    START WITH 1
    INCREMENT BY 1;

 CREATE SEQUENCE seq_asientosid
    START WITH 1
    INCREMENT BY 1;

-- PROCEDIMIENTOS ___________________________________________________________________________


-- Procedimiento Cargar_Sucursales
CREATE OR REPLACE PROCEDURE Cargar_Sucursales (
    p_ID          Sucursales.Suc_ID%TYPE,
    p_Nombre      Sucursales.Suc_Name%TYPE,
    p_DireccionID Sucursales.Suc_DirecID%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Sucursales 
    VALUES (p_ID, p_Nombre, p_DireccionID);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Sucursales;
/


-- Procedimiento Cargar_Direccion_Suc
CREATE OR REPLACE PROCEDURE Cargar_Direccion_Suc (
    p_ID          Direccion_Suc.Dir_ID%TYPE,
    p_Provincia   Direccion_Suc.Dir_Provincia%TYPE,
    p_Distrito    Direccion_Suc.Dir_Distrito%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Direccion_Suc
    VALUES (p_ID, p_Provincia, p_Distrito);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Direccion_Suc;
/


-- Procedimiento Cargar_Telefonos_Suc
CREATE OR REPLACE PROCEDURE Cargar_Telefonos_Suc (
    p_TypeID      Telefonos_Suc.TelS_TypeID%TYPE,
    p_SucursalID  Telefonos_Suc.TelS_SucursalID%TYPE,
    p_Numero      Telefonos_Suc.TelS_Number%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Telefonos_Suc
    VALUES (p_TypeID, p_SucursalID, p_Numero);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Telefonos_Suc;
/


-- Procedimiento Cargar_Email_Suc
CREATE OR REPLACE PROCEDURE Cargar_Email_Suc (
    p_TypeID      Email_Suc.EmS_TypeID%TYPE,
    p_SucursalID  Email_Suc.EmS_SucursalID%TYPE,
    p_Direccion   Email_Suc.EmS_Direccion%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Email_Suc
    VALUES (p_TypeID, p_SucursalID, p_Direccion);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Email_Suc;
/


-- Procedimiento Cargar_ColaboradoresCine
CREATE OR REPLACE PROCEDURE Cargar_ColaboradoresCine (
    p_Suc_ID          ColaboradoresCine.Col_Suc_ID%TYPE,
    p_CIP             ColaboradoresCine.Col_CIP%TYPE,
    p_Nombre          ColaboradoresCine.Col_Name%TYPE,
    p_FirstApellido   ColaboradoresCine.Col_FirstApellido%TYPE,
    p_SecApellido     ColaboradoresCine.Col_SecApellido%TYPE,
    p_Genero          ColaboradoresCine.Col_Genero%TYPE,
    p_FechaNac        ColaboradoresCine.Col_FechaNac%TYPE,
    p_Mensaje OUT VARCHAR2

) 
AS
v_Edad ColaboradoresCine.Col_Edad%TYPE;
BEGIN
    v_Edad := calc_Edad(p_FechaNac);

    INSERT INTO ColaboradoresCine
    VALUES (Seq_ColaboradoresCine.NextVal, p_Suc_ID, p_CIP, p_Nombre, p_FirstApellido, p_SecApellido, p_Genero, p_FechaNac, v_Edad);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_ColaboradoresCine;
/


-- Procedimiento Cargar_Telefonos_Colab
CREATE OR REPLACE PROCEDURE Cargar_Telefonos_Colab (
   p_TypeID           Telefonos_Colab.TelC_TypeID%TYPE,
   p_ColaboradorID    Telefonos_Colab.TelC_ColaboradorID%TYPE,
   p_Numero           Telefonos_Colab.TelC_Number%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Telefonos_Colab
    VALUES (p_TypeID, p_ColaboradorID, p_Numero);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Telefonos_Colab;
/


-- Procedimiento Cargar_Email_ColaboradoresCine
CREATE OR REPLACE PROCEDURE Cargar_Email_ColaboradoresCine (
   p_TypeID           Email_ColaboradoresCine.EmC_TypeID%TYPE,
   p_ColaboradorID    Email_ColaboradoresCine.EmC_ColaboradorID%TYPE,
   p_Direccion        Email_ColaboradoresCine.EmC_Direccion%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Email_ColaboradoresCine
    VALUES (p_TypeID, p_ColaboradorID, p_Direccion);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Email_ColaboradoresCine;
/


-- Procedimiento Cargar_Type_Email
CREATE OR REPLACE PROCEDURE Cargar_Type_Email (
   p_ID           Type_Email.TypeE_ID%TYPE,
   p_Descripcion  Type_Email.Descripcion%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Type_Email
    VALUES (p_ID, p_Descripcion);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Type_Email;
/


-- Procedimiento Cargar_Type_Telefonos
CREATE OR REPLACE PROCEDURE Cargar_Type_Telefonos (
   p_ID           Type_Telefonos.Type_ID%TYPE,
   p_Descripcion  Type_Telefonos.Descripcion%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Type_Telefonos
    VALUES (p_ID, p_Descripcion);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Type_Telefonos;
/


-- Procedimiento Cargar_Boletos
CREATE OR REPLACE PROCEDURE Cargar_Boletos (
    p_TaquillaID   Boletos.Bol_TaquillaID%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Boletos
    VALUES (Seq_Boletos.NextVal, current_timestamp, p_TaquillaID);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Boletos;
/


-- Procedimiento Cargar_Taquillas
CREATE OR REPLACE PROCEDURE Cargar_Taquillas (
   p_ID           Taquillas.Taq_ID%TYPE,
   p_Tipo_Boleto  Taquillas.Taq_Tipo_Boleto%TYPE,
   p_Precio       Taquillas.Precio%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Taquillas
    VALUES (p_ID, p_Tipo_Boleto, p_Precio);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Taquillas;
/


-- Procedimiento Cargar_Platillos
CREATE OR REPLACE PROCEDURE Cargar_Platillos (
   p_ID       Platillos.Pla_ID%TYPE,
   p_Nombre   Platillos.Pla_Name%TYPE,
   p_Precio   Platillos.Pla_Precio%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Platillos
    VALUES (p_ID, p_Nombre, p_Precio);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Platillos;
/


-- Procedimiento Cargar_Salas
CREATE OR REPLACE PROCEDURE Cargar_Salas (
   p_ID            Salas.Sal_ID%TYPE,
   p_SucursalID    Salas.Sal_SucursalID%TYPE,
   p_Tipo_SalaID   Salas.Sal_Tipo_SalaID%TYPE,
   p_PeliculaID    Salas.Sal_PeliculaID%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Salas
    VALUES (p_ID, p_SucursalID, p_Tipo_SalaID, p_PeliculaID);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Salas;
/


-- Procedimiento Cargar_Tipo_Sala
CREATE OR REPLACE PROCEDURE Cargar_Tipo_Sala (
   p_ID               Tipo_Sala.TypeS_ID%TYPE,
   p_Descripcion      Tipo_Sala.TypeS_Descripcion%TYPE,
   p_PrecioAgregado   Tipo_Sala.TypeS_PrecioAgregado%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Tipo_Sala
    VALUES (p_ID, p_Descripcion, p_PrecioAgregado);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Tipo_Sala;
/


-- Procedimiento Cargar_Asientos
/*Las filas son de la A-J en cada fila de la B-J hay 11 asientos y en la A hay 10 
en total 109 Asientos repartidos en 10 filas*/
CREATE OR REPLACE PROCEDURE Cargar_Asientos (
   P_salaid Asientos.Asi_SalaID%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    FOR v_countAsiento IN 1..109 LOOP
    IF v_countAsiento <= 10 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento, P_salaid, 'A', 'D');

    ELSIF v_countAsiento > 10 AND v_countAsiento <= 21 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 10, P_salaid, 'B', 'D');

    ELSIF v_countAsiento > 21 AND v_countAsiento <= 32 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 21, P_salaid, 'C', 'D');

    ELSIF v_countAsiento > 32 AND v_countAsiento <= 43 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 32, P_salaid, 'D', 'D');

    ELSIF v_countAsiento > 43 AND v_countAsiento <= 54 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 43, P_salaid, 'E', 'D');

    ELSIF v_countAsiento > 54 AND v_countAsiento <= 65 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 54, P_salaid, 'F', 'D');

    ELSIF v_countAsiento > 65 AND v_countAsiento <= 76 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 65, P_salaid, 'G', 'D');

    ELSIF v_countAsiento > 76 AND v_countAsiento <= 87 THEN 
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 76, P_salaid, 'H', 'D');

    ELSIF v_countAsiento > 87 AND v_countAsiento <= 98 THEN
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 87, P_salaid, 'I', 'D');

    ELSE
    INSERT INTO Asientos (Asi_ID, Asi_Num, Asi_SalaID, Asi_Fila, Asi_Estado)
    VALUES (seq_asientosid.nextval, v_countAsiento - 98, P_salaid, 'J', 'D');

    END IF;
    END LOOP;
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Asientos;
/


-- Procedimiento Cargar_Peliculas
CREATE OR REPLACE PROCEDURE Cargar_Peliculas (
   p_Nombre           Peliculas.Pel_Name%TYPE,
   p_Sinopsis         Peliculas.Pel_Sinopsis%TYPE,
   p_TypeGeneroID     Peliculas.Pel_TypeGeneroID%TYPE,
   p_ClasificacionID  Peliculas.Pel_ClasificacionID%TYPE,
   p_Estado           Peliculas.Pel_Estado%TYPE,
   p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Peliculas
    VALUES (Seq_Peliculas.NextVal, p_Nombre, p_Sinopsis, p_TypeGeneroID, p_ClasificacionID, p_Estado);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Peliculas;
/


-- Procedimiento Cargar_Tipo_Genero
CREATE OR REPLACE PROCEDURE Cargar_Tipo_Genero (
    p_Descripcion Tipo_Genero.TypeG_Descripcion%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Tipo_Genero
    VALUES (Seq_Generos.NextVal, p_Descripcion);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Tipo_Genero;
/


-- Procedimiento Cargar_Clasificacion_Peli
CREATE OR REPLACE PROCEDURE Cargar_Clasificacion_Peli (
    p_ID          Clasificacion_Peli.Cla_ID%TYPE,   
    p_Descripcion Clasificacion_Peli.Cla_Descripcion%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Clasificacion_Peli
    VALUES (p_ID, p_Descripcion);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Clasificacion_Peli;
/


-- Procedimiento Cargar_Factura_Boleto
CREATE OR REPLACE PROCEDURE Cargar_Factura_Boleto (
    p_ColaboradorID   Factura_Boleto.FactB_ColaboradorID%TYPE,
    p_Estado Factura_Boleto.FactB_Estado%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Factura_Boleto
    VALUES (Seq_Factura_Boletos.NextVal, current_timestamp, p_ColaboradorID, p_Estado, NULL);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Factura Duplicada';
    WHEN OTHERS THEN
        p_Mensaje := 'Error Code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Factura_Boleto;
/


-- Procedimiento Cargar_Factura_Dulceria
CREATE OR REPLACE PROCEDURE Cargar_Factura_Dulceria (
    p_ColaboradorID   Factura_Dulceria.FactD_ColaboradorID%TYPE,
    p_Estado Factura_Dulceria.FactD_Estado%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
BEGIN
    INSERT INTO Factura_Dulceria
    VALUES (Seq_Factura_Dulceria.NextVal, current_timestamp, p_ColaboradorID, p_Estado, NULL);
    p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error de Duplicidad.';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Cargar_Factura_Dulceria;
/



-- Procedimiento Nueva_Orden_Boleto
CREATE OR REPLACE PROCEDURE Nueva_Orden_Boleto (
    p_Boleto_ID       Orden_Boleto.OrdB_Boleto_ID%TYPE,
    p_Colaborador_ID   Factura_Boleto.FactB_ColaboradorID%TYPE,
    p_Asiento_ID      Orden_Boleto.OrdB_Asiento_ID%TYPE,
    p_Mensaje OUT VARCHAR2
) AS
v_estadoAsi Asientos.Asi_Estado%TYPE;
BEGIN
    Cargar_Factura_Boleto(p_Colaborador_ID, 'R', p_Mensaje);

    SELECT Asi_Estado INTO v_estadoAsi
    FROM Asientos
    WHERE Asi_ID = p_Asiento_ID;

    IF v_estadoAsi = 'D' THEN
    INSERT INTO Orden_Boleto
    VALUES (p_Boleto_ID, Seq_Factura_Boletos.currval, p_Asiento_ID);
    p_Mensaje := 'Operaciones completadas';
    ELSE
    P_Mensaje := 'Asiento no disponible...Escoja Otro.';
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'BOLETO NO DISPONIBLE';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Nueva_Orden_Boleto;
/


-- Procedimiento Nueva_Orden_Dulceria
CREATE OR REPLACE PROCEDURE Nueva_Orden_Dulceria (
   p_Platillo_ID      Orden_Dulceria.OrdD_Platillo_ID%TYPE,
   p_Colaborador_ID   Factura_Dulceria.FactD_ColaboradorID%TYPE,
   p_CantProductos    Orden_Dulceria.OrdD_CantProductos%TYPE,
   p_Mensaje OUT VARCHAR2
) AS

BEGIN 
    Cargar_Factura_Dulceria(p_Colaborador_ID, 'R', p_Mensaje);

    INSERT INTO Orden_Dulceria
    VALUES (p_Platillo_ID, Seq_Factura_Dulceria.currval, p_CantProductos);

p_Mensaje := 'Operaciones completadas';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        p_Mensaje := 'Error...Factura Duplicada';
    WHEN OTHERS THEN
        p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Nueva_Orden_Dulceria;
/

--Procedimiento para procesar todas las facturas de los boletos vendidos
CREATE OR REPLACE PROCEDURE Procesar_FactBoletos (
    p_Mensaje OUT VARCHAR2
) AS
CURSOR c_FBoletos IS
SELECT FactB_Estado, FactB_FechaProcesada
FROM Factura_Boleto
WHERE FactB_Estado = 'R';

BEGIN
FOR v_countFacturasB IN c_FBoletos LOOP
UPDATE Factura_Boleto SET
FactB_Estado = 'P',
FactB_FechaProcesada = CURRENT_TIMESTAMP;
END LOOP;
p_Mensaje := 'Facturas procesadas...CAJA REGISTRADORA CERRADA';
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'Error...No se pudieron procesar las facturas';
WHEN OTHERS THEN
p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Procesar_FactBoletos;
/

--Procedimiento para procesar todas las facturas de la dulceria
CREATE OR REPLACE PROCEDURE Procesar_FactDulceria (
    p_Mensaje OUT VARCHAR2
) AS
CURSOR c_FDulceria IS
SELECT FactD_Estado, FactD_FechaProcesada
FROM Factura_Dulceria
WHERE FactD_Estado = 'R';

BEGIN
FOR v_countFacturas IN c_FDulceria LOOP
UPDATE Factura_Dulceria SET
FactD_Estado = 'P',
FactD_FechaProcesada = CURRENT_TIMESTAMP;
END LOOP;
p_Mensaje := 'Facturas procesadas...CAJA REGISTRADORA CERRADA';

EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN
p_Mensaje := 'Error...No se pudieron procesar las facturas';
WHEN OTHERS THEN
p_Mensaje := 'Error code '|| SQLCODE || ': ' || SQLERRM;
COMMIT;
END Procesar_FactDulceria;
/
-- INVOCACIONES (MANUALES, NO POR CONSOLA A TRAVÉS DEL &.) ___________________________________________________________________________
--CUANDO SE HACEN INVOCACIONES SIN CONSOLA NO SE DEBEN DECLARAR VARIABLES SOLO LA DEL MENSAJE
--Invocacion de Cargar_Sucursales
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Sucursales(1, 'Cinepolis Albrook',       1, v_Mensaje);
    Cargar_Sucursales(2, 'Cinemark Albrook',        1, v_Mensaje);
    Cargar_Sucursales(3, 'Cinepolis Av Balboa',     2, v_Mensaje);
    Cargar_Sucursales(4, 'Cinepolis Los Pueblos',   3, v_Mensaje);
    Cargar_Sucursales(5, 'Cinepolis Los andes',     4, v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--Invocacion de Cargar_Direccion_Suc
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Direccion_Suc(1, 'Panama', 'Albrook',     v_Mensaje);
    Cargar_Direccion_Suc(2, 'Panama', 'Albrook',     v_Mensaje);
    Cargar_Direccion_Suc(3, 'Panama', 'Calidonia',   v_Mensaje);
    Cargar_Direccion_Suc(4, 'Panama', 'Los pueblos', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--Invocacion de Cargar_Telefonos_Suc
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Telefonos_Suc(2, 1, 500601, v_Mensaje);
    Cargar_Telefonos_Suc(2, 2, 500602, v_Mensaje);
    Cargar_Telefonos_Suc(2, 3, 500603, v_Mensaje);
    Cargar_Telefonos_Suc(2, 4, 500604, v_Mensaje); 
    Cargar_Telefonos_Suc(2, 5, 500605, v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Email_Suc
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Email_Suc(2, 1, 'Albrook@Cinepolis.com',     v_Mensaje);
    Cargar_Email_Suc(2, 2, 'Albrook@Cinemark.com',      v_Mensaje);
    Cargar_Email_Suc(2, 3, 'Balboa@Cinepolis.com',      v_Mensaje);
    Cargar_Email_Suc(2, 4, 'LosPueblos@Cinepolis.com',  v_Mensaje); 
    Cargar_Email_Suc(2, 5, 'LosAndes@Cinepolis.com',    v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);

END;
/

--Invocacion de Cargar_Colaboradores
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_ColaboradoresCine(1, 132614, 'Amador',      'Arenas',   'Serrano',    'M', '24/09/1981', v_Mensaje);
    Cargar_ColaboradoresCine(1, 521256, 'Paola',       'Acevedo',  'Pereira',    'F', '24/03/1988', v_Mensaje);
    Cargar_ColaboradoresCine(1, 871893, 'Pilar',       'Oliver',   'Benitez',    'F', '14/11/1988', v_Mensaje);
    Cargar_ColaboradoresCine(2, 427031, 'Isidro',      'Huerta',   'Alemany',    'M', '19/05/1991', v_Mensaje);
    Cargar_ColaboradoresCine(2, 264708, 'Carla',       'Chelo',    'Marcos',     'F', '27/09/1991', v_Mensaje);
    Cargar_ColaboradoresCine(3, 614798, 'Eduardo',     'Pastor',   'Ortiz',      'M', '07/11/1991', v_Mensaje);
    Cargar_ColaboradoresCine(3, 644901, 'Anastasia',   'Corral',   'Corominas',  'F', '28/05/1994', v_Mensaje);
    Cargar_ColaboradoresCine(3, 244123, 'Vicenta',     'Fernández','Calzada',    'F', '14/06/1994', v_Mensaje);
    Cargar_ColaboradoresCine(3, 467615, 'Gabriel',     'Peñalver', 'Ortuño',     'M', '10/03/1995', v_Mensaje);
    Cargar_ColaboradoresCine(4, 775110, 'Andrea',      'Martínez', 'Rincón',     'F', '22/05/1996', v_Mensaje);
    Cargar_ColaboradoresCine(4, 461895, 'José',        'Manuel',   'Albert',     'M', '08/02/2003', v_Mensaje);
    Cargar_ColaboradoresCine(4, 131103, 'Victoriano',  'Bayona',   'Pomares',    'M', '10/03/1995', v_Mensaje);
    Cargar_ColaboradoresCine(5, 923359, 'Anunciación', 'Espejo',   'Rosales',    'F', '13/03/1995', v_Mensaje);
    Cargar_ColaboradoresCine(5, 219987, 'Martín',      'Herrero',  'Font',       'M', '01/09/1991', v_Mensaje);
    Cargar_ColaboradoresCine(5, 208430, 'Julio',       'César',    'Roldan',     'M', '14/11/1988', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Telefonos_Colab
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Telefonos_Colab(1, 1,  982285, v_Mensaje);
    Cargar_Telefonos_Colab(1, 2,  654557, v_Mensaje);
    Cargar_Telefonos_Colab(2, 3,  644794, v_Mensaje);
    Cargar_Telefonos_Colab(1, 4,  131912, v_Mensaje);
    Cargar_Telefonos_Colab(1, 5,  236276, v_Mensaje);
    Cargar_Telefonos_Colab(2, 6,  138084, v_Mensaje);
    Cargar_Telefonos_Colab(1, 7,  775962, v_Mensaje);
    Cargar_Telefonos_Colab(1, 8,  979423, v_Mensaje);
    Cargar_Telefonos_Colab(2, 9,  324327, v_Mensaje);
    Cargar_Telefonos_Colab(2, 10, 705564, v_Mensaje);
    Cargar_Telefonos_Colab(1, 11, 886750, v_Mensaje);
    Cargar_Telefonos_Colab(1, 12, 607547, v_Mensaje);
    Cargar_Telefonos_Colab(2, 13, 427362, v_Mensaje);
    Cargar_Telefonos_Colab(2, 14, 542563, v_Mensaje);
    Cargar_Telefonos_Colab(2, 15, 726452, v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Email_ColaboradoresCine
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Email_ColaboradoresCine(1, 1,  'ines.pena49@nearbpo.com',          v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 2,  'sofia.sepulveda32@corpfolder.com', v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 3,  'cesar24@yahoo.com',                v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 4,  'mateo61@hotmail.com',              v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 5,  'manuel78@yahoo.com',               v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 6,  'gonzalo_gastelum@nearbpo.com',     v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 7,  'carlos_cintron@gmail.com',         v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 8,  'claudio_torres@gmail.com',         v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 9,  'rafael3@hotmail.com',              v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 10, 'soledad95@yahoo.com',              v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 11, 'iker_khalid@nearbpo.com',          v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 12, 'estela40@hotmail.com',             v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 13, 'armando23@hotmail.com',            v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 14, 'maria.karen77@nearbpo.com',        v_Mensaje);
    Cargar_Email_ColaboradoresCine(1, 15, 'josemiguel.saiz@yahoo.com',        v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Type_Email
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Type_Email(1, 'Personal', v_Mensaje);
    Cargar_Type_Email(2, 'Empresarial', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Type_Telefonos
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
    Cargar_Type_Telefonos(1, 'Personal',    v_Mensaje); 
    Cargar_Type_Telefonos(2, 'Residencial', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

-- Invocacion de cargar_taquillas
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
Cargar_Taquillas(1, 'Niño', 4.50, v_Mensaje);
Cargar_Taquillas(2, 'Adultos', 5.75, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--INVOCACION PARA CREAR BOLETOS Cargar_Boletos
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
FOR v_countBol IN 1..764 LOOP
IF v_countBol <= 382 THEN
Cargar_Boletos(1, v_Mensaje);
ELSE 
Cargar_Boletos(2, v_Mensaje);
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

-- Invocación Cargar_Tipo_Genero
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN   
    Cargar_Tipo_Genero('Acción', v_Mensaje); 
    Cargar_Tipo_Genero('Animación', v_Mensaje);
    Cargar_Tipo_Genero('Aventuras', v_Mensaje);
    Cargar_Tipo_Genero('Ciencia Ficción', v_Mensaje); 
    Cargar_Tipo_Genero('Comedia', v_Mensaje);
    Cargar_Tipo_Genero('Documental', v_Mensaje);
    Cargar_Tipo_Genero('Drama', v_Mensaje);
    Cargar_Tipo_Genero('Fantasía', v_Mensaje);
    Cargar_Tipo_Genero('Musical', v_Mensaje);
    Cargar_Tipo_Genero('Romance', v_Mensaje);
    Cargar_Tipo_Genero('Suspenso', v_Mensaje);
    Cargar_Tipo_Genero('Terror', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

-- Invocación Cargar_Clasificacion_Peli
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN   
    Cargar_Clasificacion_Peli(1, 'AA', v_Mensaje);
    Cargar_Clasificacion_Peli(2, 'A', v_Mensaje); 
    Cargar_Clasificacion_Peli(3, 'B', v_Mensaje);
    Cargar_Clasificacion_Peli(4, 'B15', v_Mensaje);
    Cargar_Clasificacion_Peli(5, 'C', v_Mensaje);
    Cargar_Clasificacion_Peli(6, 'D', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

-- Invocación Cargar_Peliculas
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN   
    Cargar_Peliculas('Black Widow', 'Natasha Romanoff, también conocida como Black Widow, se enfrenta a lo más oscuro de sus cuentas pendientes cuando surge una peligrosa conspiración que tiene lazos con su pasado. Perseguida por una fuerza que no se detendrá ante nada para derribarla, debe lidiar con su historia como espía y con las relaciones rotas que dejó a su paso mucho antes de convertirse en parte de los Vengadores.', 1, 3, 'D', v_Mensaje);
    Cargar_Peliculas('Coco', 'A pesar de la desconcertante prohibición de la generación de música de su familia, Miguel sueña con convertirse en un músico consumado como su ídolo, Ernesto de la Cruz. Desesperado por demostrar su talento, Miguel se encuentra en la deslumbrante y colorida Tierra de los Muertos siguiendo una misteriosa cadena de eventos. En el camino, se encuentra con el encantador y tramposo Héctor. Juntos, realizan un viaje extraordinario para descubrir la historia real detrás de la familia de Miguel.', 2, 2, 'D', v_Mensaje);
    Cargar_Peliculas('Uncharted: Fuera del mapa', 'Un descendiente del explorador Sir Francis Drake descubre la ubicación de la legendaria ciudad de El Dorado. Con la ayuda de su mentor Victor Sullivan y la ambiciosa periodista Elena Fischer, Nathan Drake trabajará para descubrir sus secretos, mientras sobreviven en una isla llena de piratas, mercenarios, y un misterioso enemigo, se embarcarán en una búsqueda sin precedentes por alcanzar el tesoro antes que sus perseguidores. Adaptación del aclamado videojuego homónimo.', 3, 2, 'N', v_Mensaje);
    Cargar_Peliculas('Dune', 'Paul Atreides, un joven brillante y talentoso nacido en un gran destino más allá de su entendimiento, debe viajar al planeta más peligroso del universo para asegurar el futuro de su familia y de su pueblo.', 4, 2, 'N', v_Mensaje);
    Cargar_Peliculas('Jumanji: En la selva', 'Cuatro adolescentes son absorbidos por un videojuego, en el que se convierten en avatares de personajes arquetípicos. Allí vivirán múltiples aventuras, al tiempo que buscan cómo salir de allí para volver a su mundo.', 5, 2, 'D', v_Mensaje);
    Cargar_Peliculas('Billie Eilish: el mundo es un poco borroso', 'Una mirada íntima a la trayectoria de Billie Eilish a través de la lente de R.J. Cutler, que nos muestra a la extraordinaria adolescente de gira, sobre el escenario y en casa con su familia mientras escribe y graba el álbum debut que cambió su vida.', 6, 3, 'N', v_Mensaje);
    Cargar_Peliculas('Hasta el último hombre', 'Japón, 1945. Desmond Doss (Andrew Garfield), un hombre contrario a la violencia, se alista en el ejército de EEUU para servir como médico de guerra en plena II Guerra Mundial. Tras luchar contra todo el estamento militar y enfrentarse a un juicio de guerra por su negativa a coger un rifle, consigue su objetivo y es enviado a servir como médico al frente japonés. A pesar de ser recibido con recelo por todo el batallón durante la salvaje toma de Okinawa, Desmond demuestra su valor salvando a 75 hombres heridos consiguiendo el respeto de los soldados…', 7, 3, 'D', v_Mensaje);
    Cargar_Peliculas('Morbius', 'Gravemente enfermo con un trastorno sanguíneo poco común y decidido a salvar a otros que sufren de ese mismo destino, el Dr. Morbius hace una arriesgada apuesta. Si bien al principio, parece ser un éxito radical, una oscuridad dentro de él se desata. ¿El bien prevalecerá sobre el mal o Morbius sucumbirá a sus misteriosos nuevos impulsos?', 8, 3, 'N', v_Mensaje);
    Cargar_Peliculas('The Greatest Showman', 'Celebra el nacimiento del mundo del espectáculo y habla de un visionario que se levantó de la nada para crear un espectáculo que se convirtió en una sensación mundial.', 9, 2, 'D', v_Mensaje);
    Cargar_Peliculas('Kimi no Na wa', 'Mitsuha es la hija del alcalde de una pequeña ciudad de montaña. Es una joven sencilla de escuela secundaria que vive con su hermana y su abuela y no tiene ningún reparo en que se sepa que no está interesada en los rituales sintoístas ni en ayudar a la campaña electoral de su padre. En su lugar sueña con abandonar la aburrida ciudad y probar suerte en Tokio. Taki es un chico de secundaria en Tokio que trabaja medio tiempo en un restaurante italiano y aspira a convertirse en arquitecto o artista. Cada noche tiene un extraño sueño donde se convierte… en una chica de escuela secundaria en un pequeño pueblo de montaña.', 10, 2, 'D', v_Mensaje);
    Cargar_Peliculas('Koe no Katachi', 'La historia está protagonizada por Shoya Ishida, un muchacho normal, y Shoko Nishimiya , una nueva estudiante que es sorda. Shoya no tarda mucho en dirigir a la clase a la hora de burlarse de Shoko, pero esto hace que finalmente la chica no lo soporte más y se cambie de instituto. Con esto, toda la clase pasa a meterse con Shoya por haber forzado tanto la situación. Años después, Shoya tiene el fuerte deseo de volver a ver a Shoko y pedirle perdón por lo que le hizo.', 10, 2, 'D', v_Mensaje);
    Cargar_Peliculas('A Quiet Place', 'En un mundo invadido y arrasado por unos letales extraterrestres que se guían por el sonido, Evelyn y Lee Abbott sobreviven con sus hijos en una granja aislada en el bosque, sumidos en el más profundo silencio. Mientras no hagan ruido, estarán a salvo.', 11, 3, 'D', v_Mensaje);
    Cargar_Peliculas('Insidious', 'Josh (Patrick Wilson), su esposa Renai (Rose Byrne) y sus tres hijos acaban de mudarse a una vieja casa. Pero, tras un desgraciado accidente, uno de los niños entra en coma y, al mismo tiempo, empiezan a producirse en la casa extraños fenómenos que aterrorizan a la familia.', 12, 3, 'N', v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Tipo_Sala
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
Cargar_Tipo_Sala(1, '3D', 2.25 , v_Mensaje);
Cargar_Tipo_Sala(2, 'SUBTITULADA', 0 , v_Mensaje);
Cargar_Tipo_Sala(3, 'DOBLADA', 0, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Cargar_Salas
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
Cargar_Salas(1, 1, 2, 5, v_Mensaje);
Cargar_Salas(2, 1, 2, 2, v_Mensaje);
Cargar_Salas(3, 1, 1, 10, v_Mensaje);
Cargar_Salas(4, 1, 1, 7, v_Mensaje);
Cargar_Salas(5, 1, 3, 6, v_Mensaje);
Cargar_Salas(6, 1, 3, 9, v_Mensaje);
Cargar_Salas(7, 1, 3, 11, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de cargar_asientos
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
Cargar_Asientos(1, v_Mensaje);
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

-- Invocación Cargar_Platillos
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN   
    Cargar_Platillos(1, 'Palomitas', 2.5, v_Mensaje);
    Cargar_Platillos(2, 'Soda', 1.5, v_Mensaje);
    Cargar_Platillos(3, 'Té', 1.5, v_Mensaje);
    Cargar_Platillos(4, 'Hot Dog', 2.5, v_Mensaje);
    Cargar_Platillos(5, 'Nachos', 2.5, v_Mensaje);
    Cargar_Platillos(6, 'Chocolate', 1.5, v_Mensaje);
    Cargar_Platillos(7, 'Gomitas', 1.0, v_Mensaje);
    DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/


--Invocacion de Nueva_Orden_Boleto
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
Nueva_Orden_Boleto(1, 6, 3, v_Mensaje);--Insertar las ordenes que desee y se genera la factura en e procedimientos
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

--Invocacion de Nueva_Orden_Dulceria
DECLARE
v_Mensaje VARCHAR2(100);
BEGIN
Nueva_Orden_Dulceria(1, 9, 2, v_Mensaje);--Insertar las ordenes que desee y se genera la factura en e procedimientos
DBMS_OUTPUT.PUT_LINE(v_Mensaje);
END;
/

-- FUNCIONES ___________________________________________________________________________
--Para calcular la edad de los ColaboradoresCine
CREATE OR REPLACE FUNCTION calc_Edad (
    p_fechanacim ColaboradoresCine.Col_FechaNac%TYPE)
    RETURN NUMBER AS
    BEGIN
    RETURN FLOOR(months_between(sysdate, p_fechanacim)/12);
    END calc_Edad;
    /

-- TRIGGERS ___________________________________________________________________________

--Tabla para auditoria de las Facturas 
CREATE TABLE Au_CajaRegFacturas (
TransacFactura NUMBER PRIMARY KEY NOT NULL,
FacturaID NUMBER,
ColabResp_Ant NUMBER,
ColabResp_Act NUMBER,
Tabla VARCHAR2(20),
TransacType CHAR NOT NULL,
Usuario VARCHAR(20),
TransacDATE TIMESTAMP(4),
CONSTRAINT c_TransacType CHECK (TransacType IN ('I', 'U', 'D'))
--Insert = I, Update = U, Delete = D
);

CREATE TABLE Au_CajaRegOrdenes (
TransacOrden NUMBER PRIMARY KEY NOT NULL,
OrdenID NUMBER,
TransacType CHAR NOT NULL,
Tabla VARCHAR2(20),
Usuario VARCHAR2(20),
TransacDATE TIMESTAMP(4),
CONSTRAINT c_TransacTypeOrden CHECK (TransacType IN ('I', 'U', 'D'))
--Insert = I, Update = U, Delete = D
);

--Trigger para auditar las transacciones en las tablas de factura boletos
CREATE OR REPLACE TRIGGER Audi_FacturasBoletos
AFTER INSERT OR UPDATE OR DELETE ON Factura_Boleto
FOR EACH ROW
DECLARE
v_typetransac Au_CajaRegFacturas.TransacType%TYPE;
BEGIN

IF INSERTING THEN
v_typetransac := 'I';
END IF;

IF UPDATING THEN
v_typetransac := 'U';
END IF;

IF DELETING THEN
v_typetransac := 'D';
END IF;

IF INSERTING THEN
INSERT INTO Au_CajaRegFacturas (TransacFactura, FacturaID, ColabResp_Ant, ColabResp_Act, Tabla, TransacType, Usuario, TransacDATE)
VALUES (tri_AudiFacturas.nextval, :new.FactB_ID, :new.FactB_ColaboradorID, NULL, 'Factura_Boleto', v_typetransac, User, current_timestamp);
END IF;

IF UPDATING THEN
INSERT INTO Au_CajaRegFacturas (TransacFactura, FacturaID, ColabResp_Ant, ColabResp_Act, Tabla, TransacType, Usuario, TransacDATE)
VALUES (tri_AudiFacturas.nextval, :old.FactB_ID, :old.FactB_ColaboradorID, :new.FactB_ColaboradorID, 'Factura_Boleto', v_typetransac, User, current_timestamp);
END IF;

IF DELETING THEN
INSERT INTO Au_CajaRegFacturas (TransacFactura, FacturaID, ColabResp_Ant, ColabResp_Act, Tabla, TransacType, Usuario, TransacDATE)
VALUES (tri_AudiFacturas.nextval, :old.FactB_ID, :old.FactB_ColaboradorID, :old.FactB_ColaboradorID, 'Factura_Boleto', v_typetransac, User, current_timestamp);
END IF;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END Auditoria_Facturas;
/

--TRIGGER PARA LA AUDITORIA DE LA TABLA Factura_Dulceria EN Au_CajaRegFacturas
CREATE OR REPLACE TRIGGER Audi_FacturasDulceria
AFTER INSERT OR UPDATE OR DELETE ON Factura_Dulceria
FOR EACH ROW
DECLARE
v_typetransac Au_CajaRegFacturas.TransacType%TYPE;
BEGIN

IF INSERTING THEN
v_typetransac := 'I';
END IF;

IF UPDATING THEN
v_typetransac := 'U';
END IF;

IF DELETING THEN
v_typetransac := 'D';
END IF;

IF INSERTING THEN
INSERT INTO Au_CajaRegFacturas (TransacFactura, FacturaID, ColabResp_Ant, ColabResp_Act, Tabla, TransacType, Usuario, TransacDATE)
VALUES (tri_AudiFacturas.nextval, :new.FactD_ID, :new.FactD_ColaboradorID, NULL, 'Factura_Dulceria', v_typetransac, User, current_timestamp);
END IF;

IF UPDATING THEN
INSERT INTO Au_CajaRegFacturas (TransacFactura, FacturaID, ColabResp_Ant, ColabResp_Act, Tabla, TransacType, Usuario, TransacDATE)
VALUES (tri_AudiFacturas.nextval, :old.FactD_ID, :old.FactD_ColaboradorID, :new.FactD_ColaboradorID, 'Factura_Dulceria', v_typetransac, User, current_timestamp);
END IF;

IF DELETING THEN
INSERT INTO Au_CajaRegFacturas (TransacFactura, FacturaID, ColabResp_Ant, ColabResp_Act, Tabla, TransacType, Usuario, TransacDATE)
VALUES (tri_AudiFacturas.nextval, :old.FactD_ID, :old.FactD_ColaboradorID, :old.FactD_ColaboradorID, 'Factura_Dulceria', v_typetransac, User, current_timestamp);
END IF;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END Audi_FacturasDulceria;
/

--TRIGGER PARA LA AUDITORIA DE LA TABLA Orden_Boleto Au_CajaRegOrdenes 
CREATE OR REPLACE TRIGGER Audi_OrdenBoletos
AFTER INSERT OR UPDATE OR DELETE ON Orden_Boleto
FOR EACH ROW
DECLARE
v_typetransac Au_CajaRegFacturas.TransacType%TYPE;
BEGIN

IF INSERTING THEN
v_typetransac := 'I';
END IF;

IF UPDATING THEN
v_typetransac := 'U';
END IF;

IF DELETING THEN
v_typetransac := 'D';
END IF;

IF INSERTING THEN
INSERT INTO Au_CajaRegOrdenes (TransacOrden, OrdenID, TransacType, Tabla, Usuario, TransacDATE)
VALUES (tri_AudiOrdenes.nextval, :new.OrdB_FacturaBol_ID,  v_typetransac, 'Orden_Boleto', User, current_timestamp);
END IF;

IF UPDATING THEN
INSERT INTO Au_CajaRegOrdenes (TransacOrden, OrdenID, TransacType, Tabla, Usuario, TransacDATE)
VALUES (tri_AudiOrdenes.nextval, :old.OrdB_FacturaBol_ID,  v_typetransac, 'Orden_Boleto', User, current_timestamp);
END IF;

IF DELETING THEN
INSERT INTO Au_CajaRegOrdenes (TransacOrden, OrdenID, TransacType, Tabla, Usuario, TransacDATE)
VALUES (tri_AudiOrdenes.nextval, :old.OrdB_FacturaBol_ID,  v_typetransac, 'Orden_Boleto', User, current_timestamp);
END IF;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END Audi_OrdenBoletos;
/

--TRIGGER PARA LA AUDITORIA DE LA TABLA Orden_Dulceria Au_CajaRegOrdenes 
CREATE OR REPLACE TRIGGER Audi_OrdenDulceria
AFTER INSERT OR UPDATE OR DELETE ON Orden_Dulceria
FOR EACH ROW
DECLARE
v_typetransac Au_CajaRegFacturas.TransacType%TYPE;
BEGIN

IF INSERTING THEN
v_typetransac := 'I';
END IF;

IF UPDATING THEN
v_typetransac := 'U';
END IF;

IF DELETING THEN
v_typetransac := 'D';
END IF;

IF INSERTING THEN
INSERT INTO Au_CajaRegOrdenes (TransacOrden, OrdenID, TransacType, Tabla, Usuario, TransacDATE)
VALUES (tri_AudiOrdenes.nextval, :new.OrdD_FacturaDul_ID,  v_typetransac, 'Orden_Dulceria', User, current_timestamp);
END IF;

IF UPDATING THEN
INSERT INTO Au_CajaRegOrdenes (TransacOrden, OrdenID, TransacType, Tabla, Usuario, TransacDATE)
VALUES (tri_AudiOrdenes.nextval, :old.OrdD_FacturaDul_ID,  v_typetransac, 'Orden_Dulceria', User, current_timestamp);
END IF;

IF DELETING THEN
INSERT INTO Au_CajaRegOrdenes (TransacOrden, OrdenID, TransacType, Tabla, Usuario, TransacDATE)
VALUES (tri_AudiOrdenes.nextval, :old.OrdD_FacturaDul_ID,  v_typetransac, 'Orden_Dulceria', User, current_timestamp);
END IF;

EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Error code '|| SQLCODE || ': ' || SQLERRM);

END Audi_OrdenDulceria;
/

--actualizar disponibilidad del asiento
CREATE OR REPLACE TRIGGER UpdBoletos
AFTER INSERT ON Orden_Boleto
FOR EACH ROW
BEGIN
UPDATE Asientos SET
Asi_Estado = 'N'
WHERE Asi_ID = :new.OrdB_Asiento_ID;

END UpdBoletos;
/
-- VISTAS ___________________________________________________________________________
--vista de ubicaciones de las sucursales
CREATE VIEW Vista_UbicacionesCine AS
SELECT 
S.Suc_ID "SUCURSAL NO.",
S.Suc_Name NOMBRE,
DS.Dir_Provincia PROVINCIA,
DS.Dir_Distrito DISTRITO
FROM Direccion_Suc DS
INNER JOIN Sucursales S ON DS.Dir_Id = S.Suc_DirecID;

--Vista de los contactos de la sucursal
CREATE VIEW Vista_SucursalContactos AS
SELECT 
s.Suc_ID "SUCURSAL NO.",
S.Suc_Name NOMBRE,
ts.TelS_Number TELEFONOS,
Es.EmS_Direccion CORREO
FROM Telefonos_Suc ts
INNER JOIN Sucursales S ON  ts.TelS_SucursalID = s.Suc_id
INNER JOIN Email_Suc Es ON s.Suc_id = Es.Ems_SucursalID
ORDER BY s.Suc_id asc;

--vista de los ColaboradoresCine de las sucursales
CREATE VIEW Vista_ColabCineSuc AS
SELECT
s.Suc_Name SUCURSAL,
c.Col_ID "Colaborador NO.",
c.Col_Name NOMBRE,
c.Col_FirstApellido APELLIDO,
c.Col_CIP CEDULA,
c.Col_Edad EDAD
FROM Sucursales S 
INNER JOIN ColaboradoresCine c ON s.Suc_id = c.Col_Suc_ID
ORDER BY c.Col_ID asc;

--Vista de la Dulceria
CREATE VIEW Vista_Dulceria AS
SELECT
p.Pla_ID "DULCE NO.",
p.Pla_Name DULCE,
p.Pla_Precio "B/."
FROM Platillos p;

--Vista boletos y precio
CREATE VIEW Vista_Taquilla AS
SELECT 
tq.Taq_Tipo_Boleto BOLETO,
tq.Precio "B/."
FROM Taquillas tq;

--Vista de auditoria facturas
CREATE VIEW Vista_AudiFacturas AS
SELECT
au.TransacFactura TRANSACCION,
au.FacturaID "FACTURA NO.",
au.Tabla "TIPO ORDEN",
au.TransacType "TIPO TRANSACCION",
au.Usuario USUARIO,
au.TransacDATE "FECHA TRANSACCION"
FROM Au_CajaRegFacturas au
ORDER BY au.TransacDATE asc;

--Vista de auditoria ordenes
CREATE VIEW Vista_AudiOrdenes AS
SELECT
ro.TransacOrden TRANSACCION,
ro.OrdenID "ORDEN NO.",
ro.TransacType "TIPO TRANSACCION",
ro.Tabla "TIPO ORDEN",
ro.Usuario USUARIO,
ro.TransacDATE "FECHA TRANSACCION"
FROM Au_CajaRegOrdenes ro
ORDER BY ro.TransacDATE asc;

--Vista de peliculas
CREATE VIEW Vista_Peliculas_Salas AS SELECT
p.Pel_Name NOMBRE, tg.TypeG_Descripcion GENERO,
s.sal_ID SALA, TypeS_Descripcion TIPO_SALA,
cp.Cla_Descripcion Clasificacion
FROM Tipo_Sala ts
INNER JOIN Salas s
ON ts.TypeS_ID = s.Sal_Tipo_SalaID
INNER JOIN Peliculas p
ON s.Sal_PeliculaID = p.Pel_ID
INNER JOIN Tipo_Genero tg
ON p.Pel_TypeGeneroID = tg.TypeG_ID
INNER JOIN Clasificacion_Peli cp
ON p.Pel_ClasificacionID = cp.Cla_ID
ORDER BY Pel_ID;

--Total de boletos vendidos por los colaboradores
CREATE VIEW Vista_ColabFactBoleto AS 
SELECT
cc.Col_ID, cc.Col_Name | | ' ' | | cc.Col_FirstApellido NOMBRE,
SUM(t.precio + ts.TypeS_PrecioAgregado) "TOTAL DE VENTAS"
FROM Factura_Boleto fb
INNER JOIN ColaboradoresCine cc
ON fb.FactB_ColaboradorID = cc.Col_ID
INNER JOIN Orden_Boleto ob
ON fb.FactB_ID = ob.OrdB_FacturaBol_ID
INNER JOIN Asientos a
ON ob.OrdB_Asiento_ID = a.Asi_ID
INNER JOIN Salas s
ON a.Asi_SalaID = s.Sal_ID
INNER JOIN Tipo_Sala ts
ON s.Sal_ID = ts.TypeS_ID
INNER JOIN Boletos b 
ON ob.OrdB_Boleto_ID = b.Bol_ID
INNER JOIN Taquillas t
ON b.Bol_TaquillaID = t.Taq_ID
GROUP BY cc.Col_ID, cc.Col_Name, 
cc.Col_FirstApellido;

--Vista general de las facturas de los boletos
CREATE VIEW Vista_CliFactBoleto AS SELECT
fb.FactB_ID Num_Fact, cc.Col_Name | | ' ' | | cc.Col_FirstApellido NOMBRE,
p.Pel_Name Pelicula, a.Asi_Num Asiento, t.Taq_Tipo_Boleto Boleto, 
s.Sal_ID Sala, ts.TypeS_Descripcion Tipo_Sala,
t.precio + ts.TypeS_PrecioAgregado Precio
FROM Factura_Boleto fb
INNER JOIN ColaboradoresCine cc
ON fb.FactB_ColaboradorID = cc.Col_ID
INNER JOIN Orden_Boleto ob
ON fb.FactB_ID = ob.OrdB_FacturaBol_ID
INNER JOIN Asientos a
ON ob.OrdB_Asiento_ID = a.Asi_ID
INNER JOIN Salas s
ON a.Asi_SalaID = s.Sal_ID
INNER JOIN Peliculas p
ON s.Sal_PeliculaID = p.Pel_ID
INNER JOIN Tipo_Sala ts
ON s.Sal_ID = ts.TypeS_ID
INNER JOIN Boletos b 
ON ob.OrdB_Boleto_ID = b.Bol_ID
INNER JOIN Taquillas t
ON b.Bol_TaquillaID = t.Taq_ID;

--vista de facuras de los clientes en dulceria
CREATE VIEW Vista_ClieFactDulc AS SELECT
fd.FactD_ID Num_Fact, cc.Col_Name | | ' ' | | cc.col_FirstApellido NOMBRE,
od.OrdD_CantProductos Cant, p.pla_name Platillo,
od.OrdD_CantProductos * p.pla_Precio Precio
FROM Factura_Dulceria fd
INNER JOIN ColaboradoresCine cc
ON fd.FactD_ColaboradorID = cc.Col_ID
INNER JOIN Orden_Dulceria od
ON fd.FactD_ID = od.OrdD_FacturaDul_ID
INNER JOIN Platillos p
ON od.OrdD_Platillo_ID = p.Pla_ID;

--vista de las ventas de los colaboradors en dulceria
CREATE VIEW Vista_ColabFactDulc AS SELECT
cc.Col_ID, cc.Col_Name | | ' ' | | cc.Col_FirstApellido NOMBRE,
SUM(od.OrdD_CantProductos * p.pla_Precio) TOTAL
FROM Factura_Dulceria fd
INNER JOIN ColaboradoresCine cc
ON fd.FactD_ColaboradorID = cc.Col_ID
INNER JOIN Orden_Dulceria od
ON fd.FactD_ID = od.OrdD_FacturaDul_ID
INNER JOIN Platillos p
ON od.OrdD_Platillo_ID = p.Pla_ID
GROUP BY cc.Col_ID, cc.Col_Name, 
cc.Col_FirstApellido;
