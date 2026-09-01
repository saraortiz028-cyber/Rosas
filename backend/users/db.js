const mysql = require('mysql2');

const conexion = mysql.createConnection({
    host: 'localhost',
    port: 3307, // El puerto de tu base de datos
    user: 'root',
    password: '', // Tu contraseña de MySQL si tienes una
    database: 'floristeria'
});

conexion.connect((err) => {
    if (err) {
        console.error('Error al conectar a la base de datos:', err);
        return;
    }
    console.log('¡Conectado exitosamente a la base de datos!');
});

module.exports = conexion;