-- Inserción de datos en tabla categorías 
INSERT INTO categorias (nombre, descripcion) VALUES
('Remeras', 'Remeras deportivas para entrenamiento y uso diario'),
('Shorts', 'Shorts deportivos para gimnasio y running'),
('Calzas', 'Calzas y leggings deportivos'),
('Buzos', 'Buzos y hoodies deportivos'),
('Camperas', 'Camperas y rompevientos deportivos'),
('Conjuntos', 'Conjuntos deportivos completos'),
('Zapatillas', 'Calzado deportivo'),
('Accesorios', 'Gorras, medias, bolsos y accesorios');

-- Inserción de datos en tabla talles 
INSERT INTO talles (nombre) VALUES
('XS'),
('S'),
('M'),
('L'),
('XL'),
('XXL');

-- Inserción de datos en la tabla colores
INSERT INTO colores (nombre) VALUES
('Rojo'),
('Azul'),
('Verde'),
('Amarillo'),
('Rosa'),
('Violeta'),
('Negro'),
('Blanco'),
('Gris'),
('Naranja'),
('Marrón'),
('Beige'),
('Celeste');

-- Inserción de datos en la tabla metodos_pago
INSERT INTO metodos_pago (nombre, descripcion) VALUES
('Transferencia', 'Pago mediante transferencia bancaria'),
('Tarjeta de crédito', 'Pago con tarjeta de crédito en cuotas o un solo pago'),
('Tarjeta de débito', 'Pago con tarjeta de débito'),
('Mercado Pago', 'Pago a través de la plataforma Mercado Pago'),
('Efectivo', 'Pago en efectivo en puntos habilitados');

-- Inserción de datos en la tabla estados_pedido
INSERT INTO estados_pedido (nombre, descripcion) VALUES
('Pendiente', 'Pedido creado, aún no se registró el pago'),
('Pagado', 'Pago acreditado correctamente'),
('En preparación', 'Pedido en proceso de armado'),
('Despachado', 'Pedido entregado al correo o transporte'),
('Entregado', 'Pedido entregado al cliente'),
('Cancelado', 'Pedido cancelado por el cliente o por falta de stock');

-- Inserción masiva de datos en la tbala clientes
INSERT INTO clientes
(nombre, apellido, email, telefono, direccion, codigo_postal, tipo_documento, numero_documento)
SELECT
  ELT(((n - 1) MOD 20) + 1,
    'Juan','Mateo','Santiago','Nicolas','Lucas',
    'Tomas','Martin','Benjamin','Franco','Thiago',
    'Valentina','Martina','Sofia','Camila','Lucia',
    'Mia','Julieta','Catalina','Florencia','Agustina'
  ) AS nombre,

  ELT(((n - 1) MOD 20) + 1,
    'Gonzalez','Rodriguez','Fernandez','Lopez','Martinez',
    'Garcia','Perez','Sanchez','Romero','Diaz',
    'Alvarez','Torres','Ruiz','Flores','Acosta',
    'Benitez','Medina','Herrera','Suarez','Aguirre'
  ) AS apellido,

  -- Email único terminando en @gmail.com
  LOWER(CONCAT(
    ELT(((n - 1) MOD 20) + 1,
      'Juan','Mateo','Santiago','Nicolas','Lucas',
      'Tomas','Martin','Benjamin','Franco','Thiago',
      'Valentina','Martina','Sofia','Camila','Lucia',
      'Mia','Julieta','Catalina','Florencia','Agustina'
    ),
    '.',
    ELT(((n - 1) MOD 20) + 1,
      'Gonzalez','Rodriguez','Fernandez','Lopez','Martinez',
      'Garcia','Perez','Sanchez','Romero','Diaz',
      'Alvarez','Torres','Ruiz','Flores','Acosta',
      'Benitez','Medina','Herrera','Suarez','Aguirre'
    ),
    n,
    '@gmail.com'
  )) AS email,

  CONCAT('11', LPAD(30000000 + n, 8, '0')) AS telefono,

  CONCAT(
    ELT(((n - 1) MOD 10) + 1,
      'Av. Corrientes','Av. Santa Fe','Av. Cabildo','Av. Rivadavia','Av. Belgrano',
      'Av. Callao','Av. Pueyrredon','Av. Scalabrini Ortiz','Av. Libertador','Av. Alvarez Jonte'
    ),
    ' ',
    100 + (n MOD 900)
  ) AS direccion,

  LPAD(1000 + (n MOD 9000), 4, '0') AS codigo_postal,

  'DNI' AS tipo_documento,

  -- DNI único (8 dígitos) entre 34.000.000 y 45.000.000
  CAST(34000000 + (n * 25000) AS CHAR) AS numero_documento

FROM (
  SELECT (@row := @row + 1) AS n
  FROM
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
    CROSS JOIN
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
    CROSS JOIN
    (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) c
    CROSS JOIN (SELECT @row := 0) r
  LIMIT 400
) nums;

-- Inserción masiva en la tabla productos
INSERT INTO productos (id_categoria, nombre, descripcion, precio_base)
SELECT
  c.id_categoria,

  -- NOMBRE
  CASE
    WHEN c.nombre <> 'Accesorios' THEN
      CONCAT(
        CASE c.nombre
          WHEN 'Remeras'    THEN 'Remera '
          WHEN 'Shorts'     THEN 'Short '
          WHEN 'Calzas'     THEN 'Calza '
          WHEN 'Buzos'      THEN 'Buzo '
          WHEN 'Camperas'   THEN 'Campera '
          WHEN 'Conjuntos'  THEN 'Conjunto '
          WHEN 'Zapatillas' THEN 'Zapatillas '
        END,
        ELT(t.item_n,
          'DryFit','PowerFlex','AeroMove','CoreLift','StormShield',
          'PulseRun','UrbanEdge','PeakPro','FlexMotion','AirFlow',
          'RapidDry','Endurance','Velocity','NeoActive','MaxGrip',
          'PrimeCore','ApexFit','UltraLight','HybridFit','ProSeries'
        ),
        ' ',
        ELT(((t.item_n - 1) MOD 10) + 1,'Alpha','Core','Pro','Prime','Edge','Apex','Neo','Max','Flex','Pulse')
      )

    ELSE
      -- Accesorios reales (tipo + modelo relacionado)
      CONCAT(
        ELT(t.item_n,
          'Gorra ','Guantes ','Antiparras ','Lentes ','Medias ',
          'Raqueta ','Pelota ','Botella ','Bolso ','Toalla ',
          'Muñequera ','Rodillera ','Vincha ','Cinturón running ','Bandas elásticas ',
          'Shaker ','Riñonera ','Soga de salto ','Mat yoga ','Funda celular '
        ),
        ELT(t.item_n,
          'WindShade','GripPro','FogShield','SunGuard','ComfortStep',
          'PowerStrike','BounceMax','HydraFlow','CarryFlex','QuickDry',
          'WristLock','KneeGuard','SweatBlock','RunSecure','FlexBand',
          'MixCore','PocketRun','SpeedRope','ZenGrip','SecureFit'
        ),
        ' ',
        ELT(((t.item_n - 1) MOD 10) + 1,'Alpha','Core','Pro','Prime','Edge','Apex','Neo','Max','Flex','Pulse')
      )
  END AS nombre,

  -- DESCRIPCIÓN
  CASE
    WHEN c.nombre <> 'Accesorios' THEN
      CONCAT(
        'Producto Fit-Motion: ',
        CASE c.nombre
          WHEN 'Remeras'    THEN 'remera'
          WHEN 'Shorts'     THEN 'short'
          WHEN 'Calzas'     THEN 'calza'
          WHEN 'Buzos'      THEN 'buzo'
          WHEN 'Camperas'   THEN 'campera'
          WHEN 'Conjuntos'  THEN 'conjunto'
          WHEN 'Zapatillas' THEN 'zapatillas'
        END,
        ' pensado para entrenamiento y uso diario. Modelo ',
        ELT(t.item_n,
          'DryFit','PowerFlex','AeroMove','CoreLift','StormShield',
          'PulseRun','UrbanEdge','PeakPro','FlexMotion','AirFlow',
          'RapidDry','Endurance','Velocity','NeoActive','MaxGrip',
          'PrimeCore','ApexFit','UltraLight','HybridFit','ProSeries'
        ),
        ' ',
        ELT(((t.item_n - 1) MOD 10) + 1,'Alpha','Core','Pro','Prime','Edge','Apex','Neo','Max','Flex','Pulse'),
        '.'
      )
    ELSE
      CONCAT(
        'Accesorio Fit-Motion para complementar tu entrenamiento. ',
        ELT(t.item_n,
          'Gorra','Guantes','Antiparras','Lentes','Medias',
          'Raqueta','Pelota','Botella','Bolso','Toalla',
          'Muñequera','Rodillera','Vincha','Cinturón running','Bandas elásticas',
          'Shaker','Riñonera','Soga de salto','Mat yoga','Funda celular'
        ),
        ' modelo ',
        ELT(t.item_n,
          'WindShade','GripPro','FogShield','SunGuard','ComfortStep',
          'PowerStrike','BounceMax','HydraFlow','CarryFlex','QuickDry',
          'WristLock','KneeGuard','SweatBlock','RunSecure','FlexBand',
          'MixCore','PocketRun','SpeedRope','ZenGrip','SecureFit'
        ),
        ' ',
        ELT(((t.item_n - 1) MOD 10) + 1,'Alpha','Core','Pro','Prime','Edge','Apex','Neo','Max','Flex','Pulse'),
        '.'
      )
  END AS descripcion,

  -- PRECIO
  CASE c.nombre
    WHEN 'Remeras'    THEN 12000 + (t.item_n * 350)
    WHEN 'Shorts'     THEN 15000 + (t.item_n * 450)
    WHEN 'Calzas'     THEN 18000 + (t.item_n * 500)
    WHEN 'Buzos'      THEN 28000 + (t.item_n * 650)
    WHEN 'Camperas'   THEN 42000 + (t.item_n * 900)
    WHEN 'Conjuntos'  THEN 35000 + (t.item_n * 800)
    WHEN 'Zapatillas' THEN 65000 + (t.item_n * 1200)
    ELSE                   8000 + (t.item_n * 250)
  END AS precio_base

FROM
  (SELECT 1 AS item_n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
   UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
   UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
   UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20) t
JOIN categorias c
  ON c.nombre IN (
    'Remeras','Shorts','Calzas','Buzos',
    'Camperas','Conjuntos','Zapatillas','Accesorios'
  )
ORDER BY c.id_categoria, t.item_n;

-- Inserción masiva en la tabla variantes
INSERT INTO variantes (id_producto, id_talle, id_color, precio, stock)
WITH
talles_rn AS (
  SELECT
    id_talle,
    CAST(ROW_NUMBER() OVER (ORDER BY id_talle) AS SIGNED) AS rn,
    CAST(COUNT(*) OVER () AS SIGNED) AS cnt
  FROM talles
),
colores_rn AS (
  SELECT
    id_color,
    CAST(ROW_NUMBER() OVER (ORDER BY id_color) AS SIGNED) AS rn,
    CAST(COUNT(*) OVER () AS SIGNED) AS cnt
  FROM colores
),
sel_talles AS (
  SELECT
    p.id_producto,
    t.id_talle,
    -- start en 1..cnt
    CAST((((p.id_producto * 2) % t.cnt) + 1) AS SIGNED) AS start_t,
    -- pos 1..cnt
    (MOD((t.rn - (((p.id_producto * 2) % t.cnt) + 1)) + t.cnt, t.cnt) + 1) AS pos_talle
  FROM productos p
  JOIN talles_rn t
    ON MOD((t.rn - (((p.id_producto * 2) % t.cnt) + 1)) + t.cnt, t.cnt) < 3
),
sel_colores AS (
  SELECT
    p.id_producto,
    c.id_color,
    CAST((((p.id_producto * 5) % c.cnt) + 1) AS SIGNED) AS start_c,
    (MOD((c.rn - (((p.id_producto * 5) % c.cnt) + 1)) + c.cnt, c.cnt) + 1) AS pos_color
  FROM productos p
  JOIN colores_rn c
    ON MOD((c.rn - (((p.id_producto * 5) % c.cnt) + 1)) + c.cnt, c.cnt) < 3
)
SELECT
  p.id_producto,
  st.id_talle,
  sc.id_color,
  ROUND(
    p.precio_base
    + CASE st.pos_talle WHEN 1 THEN 0 WHEN 2 THEN 500 WHEN 3 THEN 1000 END
    + CASE sc.pos_color WHEN 1 THEN 0 WHEN 2 THEN 250 WHEN 3 THEN 400 END
  , 2) AS precio,
  (10 + (p.id_producto * 3 + st.pos_talle * 7 + sc.pos_color * 11) % 70) AS stock
FROM productos p
JOIN sel_talles st  ON st.id_producto = p.id_producto
JOIN sel_colores sc ON sc.id_producto = p.id_producto;

-- Inserción masiva en la tabla pedidos
INSERT INTO pedidos (id_cliente, id_metodo_pago, id_estado_pedido, fecha_pedido, total)
SELECT
  c.id_cliente,
  mp.id_metodo_pago,
  ep.id_estado_pedido,
  DATE_SUB(NOW(), INTERVAL (n.n % 180) DAY) AS fecha_pedido,
  0.00 AS total
FROM
  -- Generador 1..1000
  (
    SELECT (@n := @n + 1) AS n
    FROM
      (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
       UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
      CROSS JOIN
      (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
       UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
      CROSS JOIN
      (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
       UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
      CROSS JOIN (SELECT @n := 0) init
    LIMIT 1000
  ) n

JOIN (
  SELECT id_cliente, (@rc := @rc + 1) AS rn
  FROM clientes
  CROSS JOIN (SELECT @rc := 0) initc
  ORDER BY id_cliente
) c
  ON c.rn = ((n.n - 1) % (SELECT COUNT(*) FROM clientes)) + 1

JOIN (
  SELECT id_metodo_pago, (@rm := @rm + 1) AS rn
  FROM metodos_pago
  CROSS JOIN (SELECT @rm := 0) initm
  ORDER BY id_metodo_pago
) mp
  ON mp.rn = ((n.n - 1) % (SELECT COUNT(*) FROM metodos_pago)) + 1

JOIN (
  SELECT id_estado_pedido, (@re := @re + 1) AS rn
  FROM estados_pedido
  CROSS JOIN (SELECT @re := 0) inite
  ORDER BY id_estado_pedido
) ep
  ON ep.rn = ((n.n - 1) % (SELECT COUNT(*) FROM estados_pedido)) + 1;

-- Inserción masiva en la tabla pedido_detalle
INSERT INTO pedido_detalle (id_pedido, id_variante, cantidad, precio_unitario, subtotal)
WITH vmap AS (
  SELECT
    id_variante,
    precio,
    ROW_NUMBER() OVER (ORDER BY id_variante) AS rn,
    COUNT(*) OVER () AS cnt
  FROM variantes
),
slots AS (
  SELECT 1 AS seq UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
),
cantidades AS (
  SELECT 1 AS seq, 1 AS cantidad
  UNION ALL SELECT 2, 2
  UNION ALL SELECT 3, 3
  UNION ALL SELECT 4, 1
  UNION ALL SELECT 5, 2
)
SELECT
  p.id_pedido,
  v.id_variante,
  ca.cantidad,
  v.precio AS precio_unitario,
  ca.cantidad * v.precio AS subtotal
FROM pedidos p
JOIN slots s
  ON s.seq <= ((p.id_pedido % 5) + 1)
JOIN cantidades ca
  ON ca.seq = s.seq
JOIN vmap v
  ON v.rn = MOD((p.id_pedido * 13) + (s.seq * 7), v.cnt) + 1
WHERE p.id_pedido <= 1000;

-- Actualización de montos totales de la tabla pedidos
UPDATE pedidos p
JOIN (
  SELECT id_pedido, SUM(subtotal) AS total_calculado
  FROM pedido_detalle
  GROUP BY id_pedido
) x ON x.id_pedido = p.id_pedido
SET p.total = x.total_calculado;
