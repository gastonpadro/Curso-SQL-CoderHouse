-- Creación del esquema (base de datos)
CREATE SCHEMA fitmotion_db;

-- Seleccionar el esquema para trabajar
USE fitmotion_db;

-- Creación de la tabla categorias
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

-- Creación de la tabla talles
CREATE TABLE talles (
    id_talle INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(10) NOT NULL UNIQUE
);

-- Creación de la tabla colores
CREATE TABLE colores (
    id_color INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL UNIQUE
);

-- Cración de la tabla metodos_pago
CREATE TABLE metodos_pago (
    id_metodo_pago INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

-- Creación de tabla estados_pedido
CREATE TABLE estados_pedido (
    id_estado_pedido INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(30) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);

-- Creación de la tabla productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    id_categoria INT NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Creación de la tabla variantes
CREATE TABLE variantes (
    id_variante INT PRIMARY KEY AUTO_INCREMENT,
    id_producto INT NOT NULL,
    id_talle INT NOT NULL,
    id_color INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_talle) REFERENCES talles(id_talle),
    FOREIGN KEY (id_color) REFERENCES colores(id_color)
);

-- Creación de la tabla clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(150),
    codigo_postal VARCHAR(10),
    tipo_documento VARCHAR(10),
    numero_documento VARCHAR(20)
);

-- Creación de la tabla pedidos
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    id_estado_pedido INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago(id_metodo_pago),
    FOREIGN KEY (id_estado_pedido) REFERENCES estados_pedido(id_estado_pedido)
);

-- Creación de la tabla pedido_detalle
CREATE TABLE pedido_detalle (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_pedido INT NOT NULL,
    id_variante INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_variante) REFERENCES variantes(id_variante)
);










