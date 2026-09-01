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