const express = require('express');
const bcrypt = require('bcrypt');
const cors = require('cors'); // <--- 1. Agregar esta línea
const db = require('./db');

const app = express();

app.use(cors()); // <--- 2. Agregar esta línea
app.use(express.json());


app.use(express.json());

// 1. REGISTRO DE CLIENTE
app.post('/api/registro', async (req, res) => {
    const { nombre, apellido, telefono, correo, password } = req.body;

    try {
        // Encriptar la contraseña
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Insertar en tu tabla 'cliente'
        const query = 'INSERT INTO cliente (nombre, apellido, teléfono, correo, password) VALUES (?, ?, ?, ?, ?)';
        
        db.query(query, [nombre, apellido, telefono, correo, hashedPassword], (err, resultado) => {
            if (err) {
                return res.status(500).json({ error: 'El correo ya está registrado o hubo un error' });
            }
            res.status(201).json({ mensaje: 'Cuenta creada con éxito', idCliente: resultado.insertId });
        });
    } catch (error) {
        res.status(500).json({ error: 'Error en el servidor' });
    }
});

// 2. INICIO DE SESIÓN (LOGIN)
app.post('/api/login', (req, res) => {
    const { correo, password } = req.body;

    const query = 'SELECT * FROM cliente WHERE correo = ?';
    
    db.query(query, [correo], async (err, resultados) => {
        if (err) return res.status(500).json({ error: 'Error en el servidor' });
        
        if (resultados.length === 0) {
            return res.status(400).json({ error: 'Correo o contraseña incorrectos' });
        }

        const cliente = resultados[0];

        // Verificar la contraseña encriptada
        const passwordValida = await bcrypt.compare(password, cliente.password);
        if (!passwordValida) {
            return res.status(400).json({ error: 'Correo o contraseña incorrectos' });
        }

        // Si todo sale bien, devolvemos los datos del cliente (sin la contraseña)
        res.json({ 
            mensaje: 'Inicio de sesión exitoso', 
            cliente: {
                id: cliente.idCliente,
                nombre: cliente.nombre,
                correo: cliente.correo
            }
        });
    });
});

// 3. REGISTRAR UNA COMPRA DE DEMOSTRACIÓN
app.post('/api/pedidos', (req, res) => {
    const { clienteId, productoId } = req.body;

    if (!clienteId || !productoId) {
        return res.status(400).json({ error: 'Faltan datos para registrar la compra' });
    }

    const productoQuery = 'SELECT idProducto, precioActual FROM producto WHERE idProducto = ?';

    db.query(productoQuery, [productoId], (productoError, productos) => {
        if (productoError) return res.status(500).json({ error: 'Error al consultar el producto' });
        if (productos.length === 0) {
            return res.status(404).json({ error: 'Producto no encontrado' });
        }

        const producto = productos[0];
        const pedidoQuery = `
            INSERT INTO pedido
            (dedicatoria, fechaPedido, nombreDestinatario, teléfonoDestinatario,
             fechaEntrega, lugarEntrega, estadoPedido, total, Cliente_idCliente)
            VALUES (?, NOW(), ?, ?, DATE_ADD(CURDATE(), INTERVAL 3 DAY), ?, ?, ?, ?)
        `;
        const pedidoDatos = [
            'Compra simulada',
            'Cliente de demostración',
            '0000000000',
            'Entrega simulada',
            'Confirmado',
            producto.precioActual,
            clienteId
        ];

        db.query(pedidoQuery, pedidoDatos, (pedidoError, resultadoPedido) => {
            if (pedidoError) return res.status(500).json({ error: 'No se pudo registrar el pedido' });

            const relacionQuery = `
                INSERT INTO pedido_has_producto
                (Pedido_idPedido, Pedido_Cliente_idCliente, Producto_idProducto)
                VALUES (?, ?, ?)
            `;

            db.query(
                relacionQuery,
                [resultadoPedido.insertId, clienteId, producto.idProducto],
                (relacionError) => {
                    if (relacionError) {
                        return res.status(500).json({ error: 'No se pudo asociar el producto al pedido' });
                    }

                    res.status(201).json({
                        mensaje: 'Compra simulada registrada',
                        idPedido: resultadoPedido.insertId
                    });
                }
            );
        });
    });
});

// 3. VER LOS PEDIDOS DE UN CLIENTE ESPECÍFICO
app.get('/api/mis-pedidos/:idCliente', (req, res) => {
    const { idCliente } = req.params;

    // Consulta para traer los pedidos del cliente y los productos asociados mediante las llaves foráneas
    const query = `
        SELECT p.idPedido, p.fechaPedido, p.estadoPedido, p.total, p.lugarEntrega, pr.nombreProducto, pr.precioActual, pr.imagen
        FROM pedido p
        JOIN pedido_has_producto php ON p.idPedido = php.Pedido_idPedido AND p.Cliente_idCliente = php.Pedido_Cliente_idCliente
        JOIN producto pr ON php.Producto_idProducto = pr.idProducto
        WHERE p.Cliente_idCliente = ?
    `;

    db.query(query, [idCliente], (err, resultados) => {
        if (err) return res.status(500).json({ error: 'Error al obtener los pedidos' });
        
        res.json({ pedidos: resultados });
    });
});

app.listen(3000, () => {
    console.log('Servidor corriendo en el puerto 3000');
});