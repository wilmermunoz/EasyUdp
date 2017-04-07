# EasyUdp
Simple conexión de protocolo UDP

EasyUdp.m - Utiliza Java de Matlab para manipular el protocolo de comunicacion (UDP) con otra aplicación o remotamente
 
EasyUdp( 'SEND',PORT, HOST, MSG) Envia un mensaje al puerto especifico
65535<PORT>1025
HOST: www.ejemplo.com, 195.134.34.194
Abrir en el firewall de la máquina receptora.
 
MSG = EasyUdp( 'RECEIVE', PORT, PACKETLENGTH) recibe un mensaje sobre el puerto especificado. PACKETLENGTH se debe especipicar el tamano del paquete esperado

MSG = EasyUdp( 'RECEIVE', PORT, PACKETLENGTH, TIMEOUT)
TIMEOUT : Tiempo espera.

[MSG, Host] = EasyUdp( 'RECEIVE', ...) 
Host: IP del receptor

Los mensajes enviados por easy_udp.m tiene formato INT8. 
Los mensajes recividos por easy_udp.m tiene formato String.

por ejemplo
  [msg, host] = EasyUdp( 'RECEIVE', 5555, 200)
  EasyUdp( 'SEND',5555, 'www.ejemplo.com', INT8('¡Hola!'))

Desarrollado en Matlab R2012
Wilmer Munoz (wilmer.munoz@correounivalle.edu.co) 2017 -- Basado en Simple UDP (judp)
