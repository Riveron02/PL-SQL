CREATE TABLE Cliente (
    Cli_ClienteID   NUMBER          NOT NULL,
    Cli_Cedula      NUMBER          NOT NULL,
    Cli_Nombre      VARCHAR2(25)    NOT NULL,
    Cli_Apellido    VARCHAR2(25)    NOT NULL,
    Cli_Sexo        CHAR            NOT NULL,
    Cli_Nacimiento  DATE            NOT NULL,
    Cli_Cod_Profesion   VARCHAR2(50)    NOT NULL,


    CONSTRAINT pk_Cli_Clienteid PRIMARY KEY (Cli_ClienteID),
    CONSTRAINT fk_Cli_Cod_Profesion FOREIGN KEY (Cli_Cod_Profesion) REFERENCES Profesion (Pro_Cod_tipo_profesion),
    CONSTRAINT c_sexo CHECK (Cli_Sexo in ('M', 'F')),
    CONSTRAINT u_Cli_Cedula UNIQUE (Cli_Cedula)
   );


CREATE TABLE Profesion (
    Pro_Cod_Profesion NUMBER NOT NULL,
    Pro_Desc_Tprof VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_Pro_Cod_Profesion PRIMARY KEY (Pro_Cod_Profesion)
)

CREATE TABLE Type_Telefono (
    Tel_Codigo_tipo_Telefono NUMBER NOT NULL,
    Tel_Desc_Typetelefono VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_Tel_Codigo_tipo_Telefono PRIMARY KEY (Tel_Codigo_tipo_Telefono)
)

CREATE TABLE Cli_Telefonos (
    Tel_ClienteID  NUMBER,
    TipT_ID         NUMBER,
    Tel_Numero      NUMBER,
    
    PRIMARY KEY (Tel_ClienteID, TipT_ID),
    CONSTRAINT fk_Tel_ClienteID FOREIGN KEY (Tel_TelefonoID) REFERENCES  Cliente (Cli_ClienteID),
    CONSTRAINT fk_TipT_ID FOREIGN KEY (TipT_ID) REFERENCES Type_Telefono (Tel_Codigo_tipo_Telefono)
);


CREATE TABLE Type_Email (
    Ema_Codigo_tipo_Email NUMBER NOT NULL,
    Ema_Desc_TypeEmail VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_Email_Codigo_tipo_Email PRIMARY KEY (Tel_Codigo_tipo_Email)
)

CREATE TABLE Cli_Email (
    Email_ClienteID  NUMBER,
    TipE_ID         NUMBER,
    Email_Direccion      NUMBER,
    PRIMARY KEY (Email_ClienteID, TipE_ID),
    CONSTRAINT fk_Email_ClienteID FOREIGN KEY (Email_ClienteID) REFERENCES  Cliente (Cli_ClienteID),
    CONSTRAINT fk_TipE_ID FOREIGN KEY (TipE_ID) REFERENCES Type_Email (Tel_Codigo_tipo_Email)
);


CREATE TABLE Type_Prestamo (
    TyPre_Codigo_tipo_Prestamo NUMBER NOT NULL,
    TyPre_Desc_TypePrestamo VARCHAR2(50) NOT NULL,
    TyPre_Tasa NUMBER NOT NULL,
    CONSTRAINT pk_Codigo_tipo_Prestamo PRIMARY KEY (TyPre_Codigo_tipo_Prestamo)
)

CREATE TABLE Prestamo (
    Pre_Cli_ClienteID   NUMBER  NOT NULL,
    Pre_Cod_tipo_prestamo NUMBER NOT NULL,
    Pre_NPrestamos      NUMBER  NOT NULL,
    Pre_Fecha_Apro      DATE    NOT NULL,
    Pre_CantAprobada    NUMBER  NOT NULL,
    Pre_LetraMensual    NUMBER  NOT NULL,
    Pre_CantPagada      NUMBER  NOT NULL,
    Pre_FechaPago       DATE    NOT NULL,

    CONSTRAINT pk_Cli_PrestamoID_Cod_tipo_pretamo PRIMARY KEY (Pre_Cli_ClienteID, Pre_Cod_tipo_prestamo),
    CONSTRAINT fk_Cli_PrestamoID FOREIGN KEY (Pre_Cli_ClienteID) REFERENCES Cliente (Cli_ClienteID),
    CONSTRAINT fk_Pre_Cod_tipo_prestamo FOREING KEY (Pre_Cod_tipo_prestamo) REFERENCES Type_Prestamo (TyPre_Codigo_tipo_Prestamo)
    );


