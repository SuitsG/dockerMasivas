import sqlite3
from datetime import datetime

# Conectar a la base de datos (se creará si no existe)
conn = sqlite3.connect('almacen.sqlite')
cursor = conn.cursor()

# Crear tablas
cursor.execute('''
CREATE TABLE IF NOT EXISTS articulos (
    idArticulo INTEGER PRIMARY KEY,
    nombreArticulo TEXT NOT NULL,
    precioArticulo REAL,
    cantidadArticulo INTEGER
)
''')

cursor.execute('''
CREATE TABLE IF NOT EXISTS personas (
    numeroDocumento INTEGER PRIMARY KEY,
    nombres TEXT NOT NULL,
    primerApellido TEXT NOT NULL,
    segundoApellido TEXT,
    fechaNacimiento DATE,
    telefono TEXT,
    direccion TEXT,
    email TEXT
)
''')

cursor.execute('''
CREATE TABLE IF NOT EXISTS ventas (
    idVenta INTEGER PRIMARY KEY,
    idComprador INTEGER NOT NULL,
    idArticulo INTEGER NOT NULL,
    cantidadProductos INTEGER NOT NULL,
    precioTotal REAL NOT NULL,
    FOREIGN KEY (idComprador) REFERENCES personas (numeroDocumento),
    FOREIGN KEY (idArticulo) REFERENCES articulos (idArticulo)
)
''')

# Datos de ejemplo para insertar
articulos_data = [
    (1, 'Laptop', 1200.50, 10),
    (2, 'Mouse', 25.99, 50),
    (3, 'Teclado', 45.00, 30),
    (4, 'Monitor', 350.00, 15),
    (5, 'Webcam', 89.99, 25),
    (6, 'Auriculares', 65.50, 40),
    (7, 'Micrófono', 120.00, 20),
    (8, 'Impresora', 450.00, 8),
    (9, 'Scanner', 280.00, 12),
    (10, 'Tablet', 599.99, 18),
    (11, 'Smartphone', 899.00, 22),
    (12, 'Cargador', 35.00, 60),
    (13, 'Cable USB', 15.50, 100),
    (14, 'Disco Duro Externo', 180.00, 14),
    (15, 'Memoria RAM', 95.00, 30),
    (16, 'Procesador', 450.00, 10),
    (17, 'Tarjeta Gráfica', 650.00, 7),
    (18, 'Fuente de Poder', 120.00, 16),
    (19, 'Case PC', 85.00, 20),
    (20, 'Ventilador', 25.00, 35)
]

personas_data = [
    (12345678, 'Juan', 'Pérez', 'González', '1990-05-15', '3001234567', 'Calle 123 #45-67', 'juan@email.com'),
    (87654321, 'María', 'López', 'Martínez', '1985-08-20', '3109876543', 'Carrera 45 #12-34', 'maria@email.com'),
    (11223344, 'Carlos', 'Rodríguez', None, '1995-03-10', '3207654321', 'Avenida 78 #90-12', 'carlos@email.com'),
    (22334455, 'Ana', 'García', 'Silva', '1992-11-25', '3151234567', 'Calle 50 #20-30', 'ana@email.com'),
    (33445566, 'Luis', 'Martínez', 'Rojas', '1988-07-08', '3162345678', 'Carrera 80 #15-25', 'luis@email.com'),
    (44556677, 'Laura', 'Hernández', 'Castro', '1993-02-14', '3173456789', 'Diagonal 40 #30-50', 'laura@email.com'),
    (55667788, 'Pedro', 'Jiménez', 'Vargas', '1987-09-30', '3184567890', 'Transversal 25 #10-20', 'pedro@email.com'),
    (66778899, 'Sofia', 'Ramírez', 'Moreno', '1991-12-05', '3195678901', 'Calle 60 #40-80', 'sofia@email.com'),
    (77889900, 'Diego', 'Torres', 'Ríos', '1994-04-18', '3206789012', 'Carrera 100 #50-60', 'diego@email.com'),
    (88990011, 'Carmen', 'Flores', 'Sánchez', '1989-06-22', '3217890123', 'Avenida 30 #70-90', 'carmen@email.com'),
    (99001122, 'Roberto', 'Vega', 'Ortiz', '1996-01-11', '3228901234', 'Calle 15 #25-35', 'roberto@email.com'),
    (10111213, 'Patricia', 'Ruiz', 'Mendoza', '1986-10-28', '3239012345', 'Carrera 65 #45-55', 'patricia@email.com'),
    (20212223, 'Fernando', 'Castro', 'Díaz', '1997-03-17', '3240123456', 'Diagonal 85 #60-70', 'fernando@email.com'),
    (30313233, 'Isabel', 'Morales', 'Guzmán', '1984-08-09', '3251234567', 'Transversal 55 #80-90', 'isabel@email.com'),
    (40414243, 'Andrés', 'Navarro', 'Reyes', '1998-05-03', '3262345678', 'Calle 95 #100-110', 'andres@email.com'),
    (50515253, 'Valentina', 'Paredes', 'Cruz', '1990-11-19', '3273456789', 'Carrera 120 #130-140', 'valentina@email.com'),
    (60616263, 'Javier', 'Méndez', 'Suárez', '1993-07-27', '3284567890', 'Avenida 150 #160-170', 'javier@email.com'),
    (70717273, 'Gabriela', 'Cortés', 'Aguilar', '1991-02-06', '3295678901', 'Calle 180 #190-200', 'gabriela@email.com'),
    (80818283, 'Miguel', 'Salazar', 'Peña', '1995-09-12', '3306789012', 'Carrera 210 #220-230', 'miguel@email.com'),
    (90919293, 'Daniela', 'Ibáñez', 'Ramos', '1987-12-24', '3317890123', 'Diagonal 240 #250-260', 'daniela@email.com')
]

ventas_data = [
    (1, 12345678, 1, 1, 1200.50),
    (2, 87654321, 2, 2, 51.98),
    (3, 11223344, 3, 1, 45.00),
    (4, 22334455, 4, 2, 700.00),
    (5, 33445566, 5, 1, 89.99),
    (6, 44556677, 6, 3, 196.50),
    (7, 55667788, 7, 1, 120.00),
    (8, 66778899, 8, 1, 450.00),
    (9, 77889900, 9, 2, 560.00),
    (10, 88990011, 10, 1, 599.99),
    (11, 99001122, 11, 1, 899.00),
    (12, 10111213, 12, 4, 140.00),
    (13, 20212223, 13, 5, 77.50),
    (14, 30313233, 14, 1, 180.00),
    (15, 40414243, 15, 2, 190.00),
    (16, 50515253, 16, 1, 450.00),
    (17, 60616263, 17, 1, 650.00),
    (18, 70717273, 18, 2, 240.00),
    (19, 80818283, 19, 3, 255.00),
    (20, 90919293, 20, 2, 50.00)
]

# Insertar datos
cursor.executemany('INSERT OR IGNORE INTO articulos VALUES (?, ?, ?, ?)', articulos_data)
cursor.executemany('INSERT OR IGNORE INTO personas VALUES (?, ?, ?, ?, ?, ?, ?, ?)', personas_data)
cursor.executemany('INSERT OR IGNORE INTO ventas VALUES (?, ?, ?, ?, ?)', ventas_data)

# Guardar cambios y cerrar conexión
conn.commit()
conn.close()

print("Datos insertados correctamente")