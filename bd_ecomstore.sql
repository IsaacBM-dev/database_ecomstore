create database if not exists bd_ecomstore;

use bd_ecomstore;

-- tabla de clientes
create table if not exists tb_clientes(
    idCliente int primary key not null,
    dniRuc varchar(15) unique not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    correo varchar(150) unique not null,
    telefono varchar(20),
    direccion varchar(255),
    fechaRegistro datetime default current_timestamp
);
select * from tb_clientes;

-- tabla de empleados
create table if not exists tb_empleados(
    idEmpleado int primary key not null,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    correo varchar(150) unique not null,
    rol enum('administrador', 'vendedor', 'logistica') not null,
    estado tinyint(1) not null default 1
);

select * from tb_empleados;

-- tabla de productos
create table if not exists tb_productos(
    idProducto int primary key not null,
    sku varchar(50) unique not null,
    nombre varchar(150) not null,
    descripcion text,
    precioActual decimal(10,2) not null,
    stock int not null,
    categoria varchar(100)
);
select * from tb_productos;

-- tabla de pedidos
create table if not exists tb_pedidos(
    idPedido int primary key not null,
    idCliente int not null,
    idEmpleado int,
    fechaPedido datetime default current_timestamp,
    estadoPedido enum('pendiente', 'procesando', 'completado', 'cancelado') not null,
    totalEstimado decimal(10,2),
    constraint fk_cliente_pedido
    foreign key (idCliente) references tb_clientes(idCliente)
    on delete cascade,
    constraint fk_empleado_pedido
    foreign key (idEmpleado) references tb_empleados(idEmpleado)
    on delete cascade
);

select * from tb_pedidos;

-- tabla detalle pedido
create table if not exists tb_detallepedido(
    idDetalle int primary key not null,
    idPedido int not null,
    idProducto int not null,
    cantidad int not null,
    precioUnitario decimal(10,2) not null,
    constraint fk_pedido_detalle
    foreign key (idPedido) references tb_pedidos(idPedido)
    on delete cascade,
    constraint fk_producto_detalle
    foreign key (idProducto) references tb_productos(idProducto)
    on delete cascade
);

-- tabla de facturacion
create table if not exists tb_facturacion(
    idFactura int primary key not null,
    idPedido int not null unique,
    fechaEmision datetime not null,
    metodoPago enum('tarjeta', 'transferencia', 'efectivo', 'pasarela') not null,
    subtotal decimal(10,2) not null,
    impuestos decimal(10,2) not null,
    totalFacturado decimal(10,2) not null,
    constraint fk_pedido_factura
    foreign key (idPedido) references tb_pedidos(idPedido)
    on delete cascade
);
select * from tb_facturacion;

-- tabla de envios
create table if not exists tb_envios(
    idEnvio int primary key not null,
    idPedido int not null unique,
    empresaTransportista varchar(100) not null,
    numeroSeguimiento varchar(100),
    estadoEnvio enum('preparacion', 'en transito', 'entregado', 'devuelto') not null,
    fechaSalida datetime,
    fechaEntregaEstimada datetime,
    constraint fk_pedido_envio
    foreign key (idPedido) references tb_pedidos(idPedido)
    on delete cascade
);

-- iniciamos la transaccion
start transaction;

-- insertamos 30 clientes
insert into tb_clientes (idCliente, dniRuc, nombres, apellidos, correo, telefono, direccion) values
(1, '71234501', 'carlos', 'mendoza', 'cmendoza@gmail.com', '987654301', 'av. cutervo 101, ica'),
(2, '71234502', 'ana', 'torres', 'atorres@gmail.com', '987654302', 'calle las dunas 202, ica'),
(3, '71234503', 'luis', 'ramirez', 'lramirez@gmail.com', '987654303', 'av. arenales 303, lima'),
(4, '71234504', 'maria', 'gomez', 'mgomez@gmail.com', '987654304', 'residencial la angostura 404, ica'),
(5, '71234505', 'jorge', 'quispe', 'jquispe@gmail.com', '987654305', 'av. san martin 505, ica'),
(6, '71234506', 'elena', 'rojas', 'erojas@gmail.com', '987654306', 'jr. ayacucho 606, lima'),
(7, '71234507', 'pedro', 'castillo', 'pcastillo@gmail.com', '987654307', 'av. municipalidad 707, ica'),
(8, '71234508', 'rosa', 'vargas', 'rvargas@gmail.com', '987654308', 'calle bolivar 808, ica'),
(9, '71234509', 'miguel', 'flores', 'mflores@gmail.com', '987654309', 'av. javier prado 909, lima'),
(10, '71234510', 'carmen', 'sanchez', 'csanchez@gmail.com', '987654310', 'urb. san isidro 1010, ica'),
(11, '71234511', 'raul', 'diaz', 'rdiaz@gmail.com', '987654311', 'calle lima 111, ica'),
(12, '71234512', 'julia', 'romero', 'jromero@gmail.com', '987654312', 'av. larco 212, lima'),
(13, '71234513', 'victor', 'fernandez', 'vfernandez@gmail.com', '987654313', 'jr. callao 313, ica'),
(14, '71234514', 'blanca', 'espinoza', 'bespinoza@gmail.com', '987654314', 'av. tupac amaru 414, lima'),
(15, '71234515', 'hector', 'chavez', 'hchavez@gmail.com', '987654315', 'urb. luren 515, ica'),
(16, '71234516', 'silvia', 'gutierrez', 'sgutierrez@gmail.com', '987654316', 'calle piura 616, ica'),
(17, '71234517', 'andres', 'cruz', 'acruz@gmail.com', '987654317', 'av. grau 717, lima'),
(18, '71234518', 'laura', 'salazar', 'lsalazar@gmail.com', '987654318', 'urb. santa maria 818, ica'),
(19, '71234519', 'diego', 'campos', 'dcampos@gmail.com', '987654319', 'av. abancay 919, lima'),
(20, '71234520', 'diana', 'vega', 'dvega@gmail.com', '987654320', 'calle chiclayo 1020, ica'),
(21, '71234521', 'omar', 'rios', 'orios@gmail.com', '987654321', 'jr. huanuco 1121, lima'),
(22, '71234522', 'isabel', 'huaman', 'ihuaman@gmail.com', '987654322', 'av. san juan 1222, ica'),
(23, '71234523', 'cesar', 'navarro', 'cnavarro@gmail.com', '987654323', 'urb. san carlos 1323, ica'),
(24, '71234524', 'paula', 'paz', 'ppaz@gmail.com', '987654324', 'av. brasil 1424, lima'),
(25, '71234525', 'ivan', 'alvarez', 'ialvarez@gmail.com', '987654325', 'calle tacna 1525, ica'),
(26, '71234526', 'sara', 'reyes', 'sreyes@gmail.com', '987654326', 'av. venezuela 1626, lima'),
(27, '71234527', 'martin', 'morales', 'mmorales@gmail.com', '987654327', 'urb. las palmeras 1727, ica'),
(28, '71234528', 'lucia', 'guerrero', 'lguerrero@gmail.com', '987654328', 'jr. cusco 1828, ica'),
(29, '71234529', 'hugo', 'cordova', 'hcordova@gmail.com', '987654329', 'av. pardo 1929, lima'),
(30, '71234530', 'marta', 'paredes', 'mparedes@gmail.com', '987654330', 'calle loreto 2030, ica');

-- insertamos 30 empleados
insert into tb_empleados (idEmpleado, nombres, apellidos, correo, rol, estado) values
(1, 'roberto', 'silva', 'rsilva@gmail.com', 'administrador', 1),
(2, 'fernanda', 'leon', 'fleon@gmail.com', 'vendedor', 1),
(3, 'gustavo', 'castro', 'gcastro@gmail.com', 'logistica', 1),
(4, 'patricia', 'mendez', 'pmendez@gmail.com', 'vendedor', 1),
(5, 'david', 'aguilar', 'daguilar@gmail.com', 'logistica', 1),
(6, 'susana', 'valdez', 'svaldez@gmail.com', 'vendedor', 1),
(7, 'emilio', 'ortiz', 'eortiz@gmail.com', 'vendedor', 1),
(8, 'carolina', 'villalobos', 'cvillalobos@gmail.com', 'logistica', 0),
(9, 'alonso', 'suarez', 'asuarez@gmail.com', 'vendedor', 1),
(10, 'marina', 'ponce', 'mponce@gmail.com', 'vendedor', 1),
(11, 'ruben', 'mejia', 'rmejia@gmail.com', 'logistica', 1),
(12, 'teresa', 'salas', 'tsalas@gmail.com', 'vendedor', 1),
(13, 'eduardo', 'bautista', 'ebautista@gmail.com', 'administrador', 1),
(14, 'gloria', 'carranza', 'gcarranza@gmail.com', 'vendedor', 1),
(15, 'felix', 'arroyo', 'farroyo@gmail.com', 'logistica', 1),
(16, 'veronica', 'cordova', 'vcordova@gmail.com', 'vendedor', 1),
(17, 'ignacio', 'figueroa', 'ifigueroa@gmail.com', 'vendedor', 1),
(18, 'roxana', 'miranda', 'rmiranda@gmail.com', 'logistica', 1),
(19, 'javier', 'vega', 'jvega@gmail.com', 'vendedor', 1),
(20, 'liliana', 'pinto', 'lpinto@gmail.com', 'vendedor', 0),
(21, 'tomas', 'guzman', 'tguzman@gmail.com', 'logistica', 1),
(22, 'angela', 'medina', 'amedina@gmail.com', 'vendedor', 1),
(23, 'marcos', 'serrano', 'mserrano@gmail.com', 'administrador', 1),
(24, 'daniela', 'cabrera', 'dcabrera@gmail.com', 'vendedor', 1),
(25, 'pablo', 'mora', 'pmora@gmail.com', 'logistica', 1),
(26, 'cecilia', 'roldan', 'croldan@gmail.com', 'vendedor', 1),
(27, 'simon', 'luna', 'sluna@gmail.com', 'vendedor', 1),
(28, 'natalia', 'ibanez', 'nibanez@gmail.com', 'logistica', 1),
(29, 'joaquin', 'velasquez', 'jvelasquez@gmail.com', 'vendedor', 1),
(30, 'raquel', 'carmona', 'rcarmona@gmail.com', 'vendedor', 1);

-- insertamos 30 productos tecnologicos
insert into tb_productos (idProducto, sku, nombre, descripcion, precioActual, stock, categoria) values
(1, 'LAP-MSI-001', 'laptop msi katana gf66', 'laptop gamer rtx 3060', 4500.00, 15, 'laptops'),
(2, 'LAP-HP-002', 'laptop hp victus 16', 'ryzen 7 y 16gb ram', 3800.00, 20, 'laptops'),
(3, 'MON-LG-003', 'monitor lg ultrawide 29', 'pantalla ips full hd', 850.00, 35, 'monitores'),
(4, 'TEC-LOG-004', 'teclado mecanico logitech g pro', 'switches blue rgb', 450.00, 50, 'perifericos'),
(5, 'MOU-RAZ-005', 'mouse razer deathadder v2', 'sensor optico 20k dpi', 280.00, 45, 'perifericos'),
(6, 'ROU-TP-006', 'router tp-link archer ax73', 'wi-fi 6 doble banda', 650.00, 25, 'redes'),
(7, 'AUD-HYP-007', 'audifonos hyperx cloud ii', 'sonido surround 7.1', 350.00, 40, 'audio'),
(8, 'SSD-SAM-008', 'ssd samsung 980 pro 1tb', 'nvme pcie gen4', 520.00, 60, 'almacenamiento'),
(9, 'RAM-COR-009', 'memoria ram corsair vengeance rgb 16gb', 'ddr4 3200mhz', 320.00, 55, 'componentes'),
(10, 'PRO-AMD-010', 'procesador amd ryzen 5 5600x', '6 nucleos 12 hilos', 850.00, 30, 'componentes'),
(11, 'PRO-INT-011', 'procesador intel core i5-12400f', '6 nucleos lga 1700', 780.00, 28, 'componentes'),
(12, 'TVI-NVI-012', 'tarjeta de video nvidia rtx 4060', '8gb gddr6 asus', 1450.00, 12, 'componentes'),
(13, 'PBA-GIG-013', 'placa base gigabyte b550m ds3h', 'micro atx am4', 450.00, 40, 'componentes'),
(14, 'FUE-COR-014', 'fuente de poder corsair cx650m', '650w 80 plus bronze', 380.00, 35, 'componentes'),
(15, 'GAB-NZX-015', 'gabinete nzxt h510', 'mid tower cristal templado', 420.00, 20, 'componentes'),
(16, 'WBC-LOG-016', 'webcam logitech c920 hd pro', 'resolucion 1080p', 310.00, 50, 'perifericos'),
(17, 'MIC-HYP-017', 'microfono hyperx quadcast', 'condensador usb rgb', 580.00, 25, 'audio'),
(18, 'IMP-EPS-018', 'impresora epson ecotank l3250', 'multifuncional wi-fi', 890.00, 18, 'impresoras'),
(19, 'HDD-SEA-019', 'disco duro seagate barracuda 2tb', 'sata 7200 rpm', 250.00, 65, 'almacenamiento'),
(20, 'UPS-APC-020', 'ups apc back-ups 1200va', 'respaldo de bateria', 750.00, 15, 'energia'),
(21, 'SWI-CIS-021', 'switch cisco sg110d-08', '8 puertos gigabit', 180.00, 30, 'redes'),
(22, 'FIR-FOR-022', 'firewall fortinet fortigate 40f', 'seguridad perimetral', 2100.00, 5, 'redes'),
(23, 'LAP-LEN-023', 'laptop lenovo thinkpad e14', 'intel core i7 ofimatica', 4100.00, 10, 'laptops'),
(24, 'MON-DEL-024', 'monitor dell p2419h 24', 'pantalla ips', 650.00, 40, 'monitores'),
(25, 'TEC-KRO-025', 'teclado redragon kumara k552', 'mecanico tenkeyless', 180.00, 70, 'perifericos'),
(26, 'MOU-LOG-026', 'mouse logitech mx master 3s', 'ergonomico inalambrico', 450.00, 25, 'perifericos'),
(27, 'SSD-KIN-027', 'ssd kingston a400 480gb', 'sata iii 2.5 pulg', 150.00, 80, 'almacenamiento'),
(28, 'HUB-UGR-028', 'hub usb-c ugreen 6 en 1', 'hdmi 4k usb 3.0', 120.00, 60, 'accesorios'),
(29, 'CAB-RED-029', 'cable de red cat 6 15m', 'patch cord ethernet', 45.00, 100, 'redes'),
(30, 'ANT-KAS-030', 'licencia kaspersky total security', 'suscripcion 1 ano', 120.00, 50, 'software');

-- insertamos 30 pedidos
insert into tb_pedidos (idPedido, idCliente, idEmpleado, estadoPedido, totalEstimado) values
(1, 1, 2, 'completado', 4500.00),
(2, 2, 4, 'procesando', 3800.00),
(3, 3, 6, 'pendiente', 850.00),
(4, 4, 7, 'completado', 730.00),
(5, 5, 9, 'cancelado', 280.00),
(6, 6, 10, 'completado', 650.00),
(7, 7, 12, 'procesando', 870.00),
(8, 8, 14, 'pendiente', 320.00),
(9, 9, 16, 'completado', 1630.00),
(10, 10, 17, 'procesando', 450.00),
(11, 11, 19, 'completado', 800.00),
(12, 12, 22, 'pendiente', 310.00),
(13, 13, 24, 'completado', 1470.00),
(14, 14, 26, 'cancelado', 250.00),
(15, 15, 27, 'completado', 750.00),
(16, 16, 29, 'procesando', 2280.00),
(17, 17, 30, 'completado', 4100.00),
(18, 18, 2, 'pendiente', 650.00),
(19, 19, 4, 'completado', 630.00),
(20, 20, 6, 'procesando', 150.00),
(21, 21, 7, 'completado', 120.00),
(22, 22, 9, 'pendiente', 45.00),
(23, 23, 10, 'completado', 120.00),
(24, 24, 12, 'cancelado', 5350.00),
(25, 25, 14, 'procesando', 280.00),
(26, 26, 16, 'completado', 850.00),
(27, 27, 17, 'pendiente', 450.00),
(28, 28, 19, 'completado', 520.00),
(29, 29, 22, 'procesando', 1450.00),
(30, 30, 24, 'completado', 890.00);

-- insertamos 30 detalles de pedido
insert into tb_detallepedido (idDetalle, idPedido, idProducto, cantidad, precioUnitario) values
(1, 1, 1, 1, 4500.00),
(2, 2, 2, 1, 3800.00),
(3, 3, 3, 1, 850.00),
(4, 4, 4, 1, 450.00),
(5, 4, 5, 1, 280.00),
(6, 6, 6, 1, 650.00),
(7, 7, 7, 1, 350.00),
(8, 7, 8, 1, 520.00),
(9, 9, 10, 1, 850.00),
(10, 9, 11, 1, 780.00),
(11, 10, 13, 1, 450.00),
(12, 11, 14, 1, 380.00),
(13, 11, 15, 1, 420.00),
(14, 12, 16, 1, 310.00),
(15, 13, 17, 1, 580.00),
(16, 13, 18, 1, 890.00),
(17, 14, 19, 1, 250.00),
(18, 15, 20, 1, 750.00),
(19, 16, 21, 1, 180.00),
(20, 16, 22, 1, 2100.00),
(21, 17, 23, 1, 4100.00),
(22, 18, 24, 1, 650.00),
(23, 19, 25, 1, 180.00),
(24, 19, 26, 1, 450.00),
(25, 20, 27, 1, 150.00),
(26, 21, 28, 1, 120.00),
(27, 22, 29, 1, 45.00),
(28, 23, 30, 1, 120.00),
(29, 28, 8, 1, 520.00),
(30, 30, 18, 1, 890.00);

-- insertamos 30 facturas
insert into tb_facturacion (idFactura, idPedido, fechaEmision, metodoPago, subtotal, impuestos, totalFacturado) values
(1, 1, '2026-05-01 10:30:00', 'tarjeta', 3813.56, 686.44, 4500.00),
(2, 2, '2026-05-01 11:15:00', 'transferencia', 3220.34, 579.66, 3800.00),
(3, 3, '2026-05-02 09:00:00', 'tarjeta', 720.34, 129.66, 850.00),
(4, 4, '2026-05-02 14:20:00', 'efectivo', 618.64, 111.36, 730.00),
(5, 5, '2026-05-03 16:45:00', 'pasarela', 237.29, 42.71, 280.00),
(6, 6, '2026-05-03 10:10:00', 'tarjeta', 550.85, 99.15, 650.00),
(7, 7, '2026-05-04 12:30:00', 'transferencia', 737.29, 132.71, 870.00),
(8, 8, '2026-05-04 15:50:00', 'tarjeta', 271.19, 48.81, 320.00),
(9, 9, '2026-05-05 08:25:00', 'transferencia', 1381.36, 248.64, 1630.00),
(10, 10, '2026-05-05 11:40:00', 'efectivo', 381.36, 68.64, 450.00),
(11, 11, '2026-05-06 13:15:00', 'tarjeta', 677.97, 122.03, 800.00),
(12, 12, '2026-05-06 17:00:00', 'pasarela', 262.71, 47.29, 310.00),
(13, 13, '2026-05-07 09:45:00', 'transferencia', 1245.76, 224.24, 1470.00),
(14, 14, '2026-05-07 14:10:00', 'tarjeta', 211.86, 38.14, 250.00),
(15, 15, '2026-05-08 16:20:00', 'efectivo', 635.59, 114.41, 750.00),
(16, 16, '2026-05-08 10:05:00', 'tarjeta', 1932.20, 347.80, 2280.00),
(17, 17, '2026-05-09 12:55:00', 'transferencia', 3474.58, 625.42, 4100.00),
(18, 18, '2026-05-09 15:30:00', 'tarjeta', 550.85, 99.15, 650.00),
(19, 19, '2026-05-10 08:40:00', 'pasarela', 533.90, 96.10, 630.00),
(20, 20, '2026-05-10 11:25:00', 'tarjeta', 127.12, 22.88, 150.00),
(21, 21, '2026-05-11 13:50:00', 'efectivo', 101.69, 18.31, 120.00),
(22, 22, '2026-05-11 16:15:00', 'tarjeta', 38.14, 6.86, 45.00),
(23, 23, '2026-05-12 09:10:00', 'transferencia', 101.69, 18.31, 120.00),
(24, 24, '2026-05-12 11:35:00', 'tarjeta', 4533.90, 816.10, 5350.00),
(25, 25, '2026-05-12 14:00:00', 'pasarela', 237.29, 42.71, 280.00),
(26, 26, '2026-05-12 15:45:00', 'tarjeta', 720.34, 129.66, 850.00),
(27, 27, '2026-05-12 16:30:00', 'transferencia', 381.36, 68.64, 450.00),
(28, 28, '2026-05-12 17:15:00', 'tarjeta', 440.68, 79.32, 520.00),
(29, 29, '2026-05-12 18:00:00', 'efectivo', 1228.81, 221.19, 1450.00),
(30, 30, '2026-05-12 19:20:00', 'tarjeta', 754.24, 135.76, 890.00);

-- insertamos 30 registros de envios
insert into tb_envios (idEnvio, idPedido, empresaTransportista, numeroSeguimiento, estadoEnvio, fechaSalida, fechaEntregaEstimada) values
(1, 1, 'olva courier', 'TRK1000001', 'entregado', '2026-05-02 08:00:00', '2026-05-04 18:00:00'),
(2, 2, 'shalom', 'TRK1000002', 'en transito', '2026-05-02 10:00:00', '2026-05-05 18:00:00'),
(3, 3, 'dhl express', 'TRK1000003', 'preparacion', null, '2026-05-06 18:00:00'),
(4, 4, 'olva courier', 'TRK1000004', 'entregado', '2026-05-03 09:00:00', '2026-05-05 18:00:00'),
(5, 5, 'marvisur', 'TRK1000005', 'devuelto', '2026-05-04 08:30:00', '2026-05-06 18:00:00'),
(6, 6, 'shalom', 'TRK1000006', 'entregado', '2026-05-04 11:00:00', '2026-05-07 18:00:00'),
(7, 7, 'olva courier', 'TRK1000007', 'en transito', '2026-05-05 09:15:00', '2026-05-08 18:00:00'),
(8, 8, 'dhl express', 'TRK1000008', 'preparacion', null, '2026-05-09 18:00:00'),
(9, 9, 'shalom', 'TRK1000009', 'entregado', '2026-05-06 08:45:00', '2026-05-08 18:00:00'),
(10, 10, 'olva courier', 'TRK1000010', 'en transito', '2026-05-06 14:00:00', '2026-05-09 18:00:00'),
(11, 11, 'marvisur', 'TRK1000011', 'entregado', '2026-05-07 10:30:00', '2026-05-10 18:00:00'),
(12, 12, 'shalom', 'TRK1000012', 'preparacion', null, '2026-05-11 18:00:00'),
(13, 13, 'olva courier', 'TRK1000013', 'entregado', '2026-05-08 09:00:00', '2026-05-10 18:00:00'),
(14, 14, 'dhl express', 'TRK1000014', 'devuelto', '2026-05-08 11:30:00', '2026-05-11 18:00:00'),
(15, 15, 'shalom', 'TRK1000015', 'entregado', '2026-05-09 08:15:00', '2026-05-11 18:00:00'),
(16, 16, 'olva courier', 'TRK1000016', 'en transito', '2026-05-09 15:00:00', '2026-05-12 18:00:00'),
(17, 17, 'marvisur', 'TRK1000017', 'entregado', '2026-05-10 09:30:00', '2026-05-12 18:00:00'),
(18, 18, 'shalom', 'TRK1000018', 'preparacion', null, '2026-05-13 18:00:00'),
(19, 19, 'olva courier', 'TRK1000019', 'entregado', '2026-05-11 08:45:00', '2026-05-13 18:00:00'),
(20, 20, 'dhl express', 'TRK1000020', 'en transito', '2026-05-11 14:20:00', '2026-05-14 18:00:00'),
(21, 21, 'shalom', 'TRK1000021', 'entregado', '2026-05-12 09:00:00', '2026-05-14 18:00:00'),
(22, 22, 'olva courier', 'TRK1000022', 'preparacion', null, '2026-05-15 18:00:00'),
(23, 23, 'marvisur', 'TRK1000023', 'entregado', '2026-05-12 10:15:00', '2026-05-15 18:00:00'),
(24, 24, 'shalom', 'TRK1000024', 'devuelto', '2026-05-12 11:30:00', '2026-05-16 18:00:00'),
(25, 25, 'olva courier', 'TRK1000025', 'en transito', '2026-05-12 13:00:00', '2026-05-16 18:00:00'),
(26, 26, 'dhl express', 'TRK1000026', 'entregado', '2026-05-12 14:45:00', '2026-05-17 18:00:00'),
(27, 27, 'shalom', 'TRK1000027', 'preparacion', null, '2026-05-17 18:00:00'),
(28, 28, 'olva courier', 'TRK1000028', 'entregado', '2026-05-12 16:30:00', '2026-05-18 18:00:00'),
(29, 29, 'marvisur', 'TRK1000029', 'en transito', '2026-05-12 17:15:00', '2026-05-18 18:00:00'),
(30, 30, 'shalom', 'TRK1000030', 'entregado', '2026-05-12 19:30:00', '2026-05-19 18:00:00');

-- confirmamos guardar
commit;

-- mostrar tablas creadas
show tables;

-- ver datos insertados en cada tabla
select * from tb_clientes;
select * from tb_empleados;
select * from tb_pedidos;
select * from tb_facturacion;
select * from tb_detallepedido;
select * from tb_envios;
select * from tb_productos;

-- insertar nuevo cliente
delimiter &&
create procedure sp_agregar_cliente(
    in p_idC int,
    in p_dni varchar(15),
    in p_nom varchar(100),
    in p_ape varchar(100),
    in p_correo varchar(150),
    in p_tel varchar(20),
    in p_dir varchar(255)
)
begin
    insert into tb_clientes(idCliente, dniRuc, nombres, apellidos, correo, telefono, direccion)
    values(p_idC, p_dni, p_nom, p_ape, p_correo, p_tel, p_dir);
end &&
delimiter ;

call sp_agregar_cliente(31, '71234599', 'luis', 'salvatierra', 'lsalva@gmail.com', '987654399', 'av. los maestros 123, ica');
call sp_agregar_cliente(32, '71234560', 'roberto', 'palacios', 'rpalacios@gmail.com', '987654360', 'urb. san joaquin h-12, arequipa');
call sp_agregar_cliente(33, '71234561', 'sofia', 'benavides', 'sbenavides@gmail.com', '987654361', 'av. los libertadores 450, lima');
call sp_agregar_cliente(34, '71234562', 'juan', 'de la cruz', 'jdelacruz@gmail.com', '987654362', 'calle pimentel 215, tacna');

-- seleccionar columnas especificas
select p.idPedido, p.fechaPedido, c.nombres
from tb_pedidos p
inner join tb_clientes c
on p.idCliente = c.idCliente;

-- consulta con like 
select * from tb_clientes
where correo like '%gmail.com';
-- consulta con where
select * from tb_productos
where stock < 20;
-- consulta con order by  
select * from tb_productos
order by precioActual desc;

-- consulta con inner join
select * from tb_pedidos p
inner join tb_clientes c
on p.idCliente = c.idCliente;

-- listar pedidos que estan pendientes
delimiter //
create procedure sp_pedidos_pendientes()
begin
    select ped.idPedido, c.nombres, c.apellidos, ped.fechaPedido, ped.totalEstimado
    from tb_pedidos ped
    join tb_clientes c on ped.idCliente = c.idCliente
    where ped.estadoPedido = 'pendiente'
    order by ped.fechaPedido asc;
end //
delimiter ;

call sp_pedidos_pendientes();

-- actualizar precio de un producto
delimiter %%
create procedure sp_actualizar_precio(
    in p_idP int,
    in p_precio decimal(10,2)
)
begin
    update tb_productos
    set precioActual = p_precio
    where idProducto = p_idP;
end %%
delimiter ;

call sp_actualizar_precio(1, 4250.00);
call sp_actualizar_precio(5, 245.00);
call sp_actualizar_precio(3, 799.90);

-- agregar stock de producto
delimiter %%
create procedure agregar_stock(
	in p_idProducto int,
    in p_stock int
)
begin
	declare v_stock int;
    start transaction;
    select stock
    into v_stock
    from tb_productos
    where idProducto = p_idProducto;
    -- validamos que no sobrepase el limite
    if p_stock > 100 then
        select "Cantidad sobrepasa el limite permitido" as mensaje;
        rollback;
	else
		if (v_stock + p_stock) > 200 then
			select "Stock excedido" as mensaje;
            rollback;
		else
			update tb_productos
            set stock = stock + p_stock
            where idProducto = p_idProducto;
            commit;
            select "Stock actualizado" as mensaje;
		end if;
	end if;
end%%
delimiter ;

select * from tb_productos;
call agregar_stock(1,10);

-- transaccion segura: registra pedido y descuenta stock
delimiter //
create procedure sp_registrar_compra(
    in p_idDetalle int,
    in p_idPedido int,
    in p_idProducto int,
    in p_cantidad int
)
begin
    declare v_stock int;
    declare v_precio decimal(10,2);
    start transaction;
    select stock, precioActual
    into v_stock, v_precio
    from tb_productos
    where idProducto = p_idProducto;
    if v_stock >= p_cantidad then
        update tb_productos
        set stock = stock - p_cantidad
        where idProducto = p_idProducto;
        insert into tb_detallepedido(idDetalle, idPedido, idProducto, cantidad, precioUnitario)
        values(p_idDetalle, p_idPedido, p_idProducto, p_cantidad, v_precio);
        commit;
        select "compra registrada" as mensaje;
    else
        rollback;
        select "stock insuficiente" as mensaje;
    end if;
end //
delimiter ;

call sp_registrar_compra(31, 1, 1, 1);
call sp_registrar_compra(32, 2, 2, 1);
call sp_registrar_compra(33, 3, 5, 3);
call sp_registrar_compra(34, 4, 12, 2);
call sp_registrar_compra(35, 5, 9, 2);
call sp_registrar_compra(36, 6, 5, 4);
call sp_registrar_compra(37, 7, 1, 4);

-- obtener info de productos mas vendidos
delimiter %%
create procedure sp_productos_mas_vendidos()
begin
    select p.nombre, sum(dp.cantidad) as totalVendidos, sum(dp.cantidad * dp.precioUnitario) as ingresosGenerados
    from tb_productos p
    join tb_detallepedido dp on p.idProducto = dp.idProducto
    group by p.idProducto, p.nombre
    order by totalVendidos desc;
end %%
delimiter ;

call sp_productos_mas_vendidos();