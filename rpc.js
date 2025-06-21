const { Client } = require('discord-rpc');
const fs = require('fs');
const path = require('path');

const clientId = '1340306512396161066'; 
const rpc = new Client({ transport: 'ipc' });
const versionFile = path.join(process.env.TEMP, 'mc_version.txt');

function updatePresence() {
    try {
        const version = fs.readFileSync(versionFile, 'utf-8').trim();
        rpc.setActivity({
            details: `Jugando a ${version}`,
            state: 'Bedrock',
            largeImageKey: 'no hay icono xd', 
            smallImageKey: 'no hay icono xd',
            startTimestamp: new Date(),
        });
    } catch (error) {
        console.error('Error al leer la versión:', error);
    }
}

rpc.on('ready', () => {
    console.log('RPC Conectado!');
    console.log('El Discrod RPC Se ha iniciado, puedes cerrar esta ventana al finalizar tu juego');
    updatePresence();
    setInterval(updatePresence, 15000);
});

rpc.login({ clientId }).catch(console.error);

process.stdin.resume();