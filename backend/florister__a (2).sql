-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 18-06-2026 a las 03:54:28
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `floristería`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `idCliente` int(11) NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `apellido` varchar(45) NOT NULL,
  `teléfono` varchar(45) NOT NULL,
  `correo` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ocasion`
--

CREATE TABLE `ocasion` (
  `id_ocasion` int(11) NOT NULL,
  `nombre_ocasion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ocasion`
--

INSERT INTO `ocasion` (`id_ocasion`, `nombre_ocasion`) VALUES
(10, 'Boda'),
(11, 'Cumpleaños'),
(12, 'Ceremonias Religiosas'),
(14, 'Eventos Corporativos'),
(15, 'Actos y Graduaciones');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `idPedido` int(11) NOT NULL,
  `dedicatoria` varchar(255) DEFAULT NULL,
  `fechaPedido` datetime NOT NULL,
  `nombreDestinatario` varchar(100) NOT NULL,
  `teléfonoDestinatario` varchar(20) NOT NULL,
  `fechaEntrega` date DEFAULT NULL,
  `lugarEntrega` varchar(255) NOT NULL,
  `estadoPedido` varchar(45) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `Cliente_idCliente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_has_producto`
--

CREATE TABLE `pedido_has_producto` (
  `Pedido_idPedido` int(11) NOT NULL,
  `Pedido_Cliente_idCliente` int(11) NOT NULL,
  `Producto_idProducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idProducto` int(11) NOT NULL,
  `nombreProducto` varchar(45) NOT NULL,
  `precioActual` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `id_tipo` int(11) DEFAULT NULL,
  `id_ocasion` int(11) DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `nombreProducto`, `precioActual`, `stock`, `id_tipo`, `id_ocasion`, `imagen`) VALUES
(1000, 'Promesa Eterna', 1800.00, 15, 2, 10, 'boda/Promesa_Eterna_Ramo_novia_clasico.jpg'),
(1001, 'Elegancia Imperial', 3500.00, 10, 3, 10, 'boda/Elegancia_Imperial_Pedestal_lirios.jpg'),
(1002, 'Centro de Mesa Distinción', 850.00, 8, 3, 10, 'boda/Centro_Mesa_Distincion _Base_baja_follaje.jpg'),
(1003, 'Boutonniere Real', 250.00, 20, 5, 10, 'boda/Boutonniere_Real_Azahar_para_novio.jpg'),
(1004, 'Amanecer Festivo', 950.00, 15, 3, 11, 'cumple/Amanecer_Festivo_Girasoles_gerberas_base_madera.jpg'),
(1005, 'Encanto Preservado', 600.00, 8, 2, 11, 'cumple/Encanto_Preservado _Mini_bouquet_flores_secas.jpg'),
(1006, 'Dulce Detalle', 150.00, 20, 4, 11, 'cumple/Dulce_Detalle_Rosa_individual_cono_decorativo.jpg'),
(1007, 'Caja Sorpresa', 1400.00, 10, 3, 11, 'cumple/Caja_sorpresa_premium.jpeg'),
(1008, 'Pureza Espiritual', 1200.00, 6, 3, 12, 'religiosa/Pureza_Espiritual.jpg'),
(1009, 'Andas Procesionales Mini', 4500.00, 4, 3, 12, 'religiosa/Andas_Procesionales_Mini.jpg'),
(1010, 'Arreglo de Atril o Púlpito Premium', 1600.00, 8, 3, 12, 'religiosa/Arreglo_Pulpito_Premiun.png'),
(1011, 'Pódium Corporativo Vanguardia', 1500.00, 7, 3, 14, 'corporativos/Podium_Corporativo_Vanguardia.jpg'),
(1012, 'Centro de Mesa Ejecutivo', 750.00, 12, 3, 14, 'corporativos/Centro_Mesa_Ejecutivo.jpeg'),
(1013, 'Bouquet de Bienvenida', 500.00, 7, 2, 14, 'corporativos/Bouquet_Bienvenida.png'),
(1014, 'Arreglo de Pódium Patriótico', 1800.00, 9, 3, 15, 'Actos_graduacion/Arreglo_Podium_Patriotico.png'),
(1015, 'Bouquet de Promoción Exclusivo', 450.00, 10, 2, 15, 'Actos_graduacion/Bouquet_Promoción_Exclusivo.png'),
(1016, 'Arreglo de Mesa Presidencial', 2500.00, 5, 3, 15, 'Actos_graduacion/Arreglo_Mesa_Presidencial.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo`
--

CREATE TABLE `tipo` (
  `id_tipo` int(11) NOT NULL,
  `nombre_tipo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo`
--

INSERT INTO `tipo` (`id_tipo`, `nombre_tipo`) VALUES
(1, 'Flores sueltas'),
(2, 'Ramos'),
(3, 'Arreglos'),
(4, 'Detalle individual'),
(5, 'Accesorios');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`idCliente`);

--
-- Indices de la tabla `ocasion`
--
ALTER TABLE `ocasion`
  ADD PRIMARY KEY (`id_ocasion`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`idPedido`,`Cliente_idCliente`),
  ADD KEY `fk_Pedido_Cliente_idx` (`Cliente_idCliente`);

--
-- Indices de la tabla `pedido_has_producto`
--
ALTER TABLE `pedido_has_producto`
  ADD PRIMARY KEY (`Pedido_idPedido`,`Pedido_Cliente_idCliente`,`Producto_idProducto`),
  ADD KEY `fk_Pedido_has_Producto_Producto1_idx` (`Producto_idProducto`),
  ADD KEY `fk_Pedido_has_Producto_Pedido1_idx` (`Pedido_idPedido`,`Pedido_Cliente_idCliente`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD KEY `fk_producto_tipo` (`id_tipo`),
  ADD KEY `fk_producto_ocasion` (`id_ocasion`);

--
-- Indices de la tabla `tipo`
--
ALTER TABLE `tipo`
  ADD PRIMARY KEY (`id_tipo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `idCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT de la tabla `ocasion`
--
ALTER TABLE `ocasion`
  MODIFY `id_ocasion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `idPedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5000;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idProducto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1017;

--
-- AUTO_INCREMENT de la tabla `tipo`
--
ALTER TABLE `tipo`
  MODIFY `id_tipo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_Pedido_Cliente` FOREIGN KEY (`Cliente_idCliente`) REFERENCES `cliente` (`idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `pedido_has_producto`
--
ALTER TABLE `pedido_has_producto`
  ADD CONSTRAINT `fk_Pedido_has_Producto_Pedido1` FOREIGN KEY (`Pedido_idPedido`,`Pedido_Cliente_idCliente`) REFERENCES `pedido` (`idPedido`, `Cliente_idCliente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Pedido_has_Producto_Producto1` FOREIGN KEY (`Producto_idProducto`) REFERENCES `producto` (`idProducto`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `fk_producto_ocasion` FOREIGN KEY (`id_ocasion`) REFERENCES `ocasion` (`id_ocasion`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_producto_tipo` FOREIGN KEY (`id_tipo`) REFERENCES `tipo` (`id_tipo`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
