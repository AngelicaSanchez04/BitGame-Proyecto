CREATE DATABASE BitGames;
USE BitGames;

-- USUARIOS
CREATE TABLE Usuarios (
    ID_Usuario INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Apellido_Mat VARCHAR(100),
    Apellido_Pat VARCHAR(100),
    Correo VARCHAR(100) UNIQUE,
    Telefono VARCHAR(20),
    Fecha_Nacimiento VARCHAR(100),
    País_Región VARCHAR(100),
    Contrasena VARCHAR(255),
    Dirección TEXT
);

-- JUEGOS
CREATE TABLE Juego (
    ID_Juego INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Genero VARCHAR(100),
    Fecha_Publicacion DATE,
    Clasificacion VARCHAR(100),
    Restriccion_Edad VARCHAR(100),
    Precio DECIMAL(6,2),
    Marca VARCHAR(50),
    Descripcion TEXT,
    Desarrollador VARCHAR(100),
    Etiquetas VARCHAR(100),
    Plataformas VARCHAR(100),
    Disponible BOOLEAN DEFAULT TRUE
);

-- BIBLIOTECA
CREATE TABLE Biblioteca_Usuario (
    ID_Usuario INT,
    ID_Juego INT,
    Fecha_Agregado DATETIME DEFAULT CURRENT_TIMESTAMP,
    Estado_instalacion ENUM('instalado', 'no_instalado', 'desinstalado') DEFAULT 'no_instalado',
    Favorito BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (ID_Usuario, ID_Juego),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario),
    FOREIGN KEY (ID_Juego) REFERENCES Juego(ID_Juego)
);
-- Tarjeta --
CREATE TABLE Datos_Tarjeta (
    ID_tarjeta INT NOT NULL PRIMARY KEY,
    Nombre_Propietario VARCHAR(100),
    Ultimos_4_digitos VARCHAR(4),
    Tipo_tarjeta VARCHAR(20),
    Token_pago VARCHAR(255), 
    Fecha_expiracion DATE,
    Fecha_registro DATETIME,
    Activo BOOLEAN
);
-- CARRITO
CREATE TABLE Carrito (
    ID_Carrito INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

-- CARRITO DETALLE
CREATE TABLE Carrito_Detalle (
    ID_Carrito INT,
    ID_Juego INT,
    Cantidad INT,
    Precio_unitario DECIMAL(10,2),
    PRIMARY KEY (ID_Carrito, ID_Juego),
    FOREIGN KEY (ID_Carrito) REFERENCES Carrito(ID_Carrito),
    FOREIGN KEY (ID_Juego) REFERENCES Juego(ID_Juego)
);

-- VENTA
CREATE TABLE Venta (
    ID_Venta INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT NOT NULL,
    Fecha_Compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    Metodo_Pago VARCHAR(100),
    Total DECIMAL(10,2),
    FOREIGN KEY (ID_Usuario) REFERENCES Usuarios(ID_Usuario)
);

-- DETALLE DE VENTA
CREATE TABLE Detalle_Venta (
    ID_Venta INT,
    ID_Juego INT,
    Cantidad INT,
    Precio_unitario DECIMAL(10,2),
    PRIMARY KEY (ID_Venta, ID_Juego),
    FOREIGN KEY (ID_Venta) REFERENCES Venta(ID_Venta),
    FOREIGN KEY (ID_Juego) REFERENCES Juego(ID_Juego)
);

-- VISTAS --
-- Total de productos por marca --
CREATE VIEW Vista_Total_Productos_Por_Marca AS
SELECT Marca, COUNT(*) AS Total_Productos
FROM Juego
GROUP BY Marca;

-- Total de ventas por cliente --
CREATE VIEW Vista_Total_Ventas_Por_Cliente AS
SELECT u.ID_Usuario, CONCAT(u.Nombre, ' ', u.Apellido_Pat, ' ', u.Apellido_Mat) AS Nombre_Completo,
       COUNT(v.ID_Venta) AS Total_Compras, SUM(v.Total) AS Monto_Total
FROM Usuarios u
JOIN Venta v ON u.ID_Usuario = v.ID_Usuario
GROUP BY u.ID_Usuario;

-- PROCEDIMIENTOS--
-- Alta de juego --
DELIMITER //

CREATE PROCEDURE Alta_Juego (
    IN p_Nombre VARCHAR(100),
    IN p_Genero VARCHAR(100),
    IN p_Fecha DATE,
    IN p_Clasificacion VARCHAR(100),
    IN p_Restriccion VARCHAR(100),
    IN p_Precio DECIMAL(6,2),
    IN p_Marca VARCHAR(50),
    IN p_Descripcion TEXT,
    IN p_Desarrollador VARCHAR(100),
    IN p_Etiquetas VARCHAR(100),
    IN p_Plataformas VARCHAR(100)
)
BEGIN
    INSERT INTO Juego (
        Nombre, Genero, Fecha_Publicacion, Clasificacion, Restriccion_Edad,
        Precio, Marca, Descripcion, Desarrollador, Etiquetas, Plataformas, Disponible
    )
    VALUES (
        p_Nombre, p_Genero, p_Fecha, p_Clasificacion, p_Restriccion,
        p_Precio, p_Marca, p_Descripcion, p_Desarrollador, p_Etiquetas, p_Plataformas, TRUE
    );
END //

DELIMITER ;

-- Baja de juego --
DELIMITER //

CREATE PROCEDURE Baja_Juego (IN p_ID_Juego INT)
BEGIN
    UPDATE Juego
    SET Disponible = FALSE
    WHERE ID_Juego = p_ID_Juego;
END //

DELIMITER ;

-- Alta de cliente --
DELIMITER //

CREATE PROCEDURE Alta_Usuario (
    IN p_Nombre VARCHAR(100),
    IN p_ApeMat VARCHAR(100),
    IN p_ApePat VARCHAR(100),
    IN p_Correo VARCHAR(100),
    IN p_Telefono VARCHAR(20),
    IN p_FechaNacimiento VARCHAR(100),
    IN p_Pais VARCHAR(100),
    IN p_Contrasena VARCHAR(255),
    IN p_Direccion TEXT
)
BEGIN
    INSERT INTO Usuarios (
        Nombre, Apellido_Mat, Apellido_Pat, Correo, Telefono,
        Fecha_Nacimiento, País_Región, Contrasena, Dirección
    )
    VALUES (
        p_Nombre, p_ApeMat, p_ApePat, p_Correo, p_Telefono,
        p_FechaNacimiento, p_Pais, p_Contrasena, p_Direccion
    );
END //

DELIMITER ;

-- Baja de cliente --
DELIMITER //

CREATE PROCEDURE Baja_Usuario (IN p_ID INT)
BEGIN
    DELETE FROM Usuarios
    WHERE ID_Usuario = p_ID;
END //

DELIMITER ;

