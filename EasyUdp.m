function [varargout] = EasyUdp(S_accion,varargin)
%
% EasyUdp.m - Utiliza Java de Matlab para manipular el protocolo de comunicacion
% (UDP) con otra aplicación o remotamente
% 
% EasyUdp( 'SEND',PORT, HOST, MSG) Envia un mensaje al puerto especifico
% 65535<PORT>1025
% HOST: www.ejemplo.com, 195.134.34.194
% abrir en el firewall de la máquina receptora.
% 
% MSG = EasyUdp( 'RECEIVE', PORT, PACKETLENGTH) recibe un mensaje sobre el
% puerto especificado. PACKETLENGTH se debe especipicar el tamano del
% paquete esperado
% 
% MSG = EasyUdp( 'RECEIVE', PORT, PACKETLENGTH, TIMEOUT)
% TIMEOUT : Tiempo espera.
% 
% [MSG, Host] = EasyUdp( 'RECEIVE', ...) 
% Host: IP del receptor
% 
% Los mensajes enviados por easy_udp.m tiene formato INT8. 
% Los mensajes recividos por easy_udp.m tiene formato String.
% 
% por ejemplo
%   [msg, host] = EasyUdp( 'RECEIVE', 5555, 200)
%   EasyUdp( 'SEND',5555, 'www.ejemplo.com', INT8('¡Hola!'))
% 
% Desarrollado en Matlab R2012
% Wilmer Munoz (wilmer.munoz@correounivalle.edu.co) 2017 -- Tomado de
% Simple UDP (judp)
%-------------------------------------------------------------------------

SEND = 1;
RECEIVE = 2;
tiempo_default = 1000;
if strcmpi(S_accion,'send')
    accion = SEND;

    if nargin < 4
        error([nombre_archivo '.m--SEND requiere cuatro argumentos de entrada']);
    end 
    puerto = varargin{1};
    host = varargin{2};
    mensaje = varargin{3};
    
elseif strcmpi(S_accion,'receive')
    accion = RECEIVE;
    
    if nargin < 3
        error([nombre_archivo '.m--RECEIVE Requiere tres argumentos de entrada.']);
    end 
    
    puerto = varargin{1};
    tamano_paquete = varargin{2};
    
    tiempo_conexion = tiempo_default;
    
    if nargin > 3
        tiempo_conexion = varargin{3};
    end 
    
else
    error([nombre_archivo '.m--Error entrada ''' S_accion ''.']);
end 

if ~isnumeric(puerto) || rem(puerto,1)~=0 || puerto < 1025 || puerto > 65535
    error([nombre_archivo '.m--Puertos entre 1025 y 65535.']);
end 

if accion == SEND
    if ~ischar(host)
        error([nombre_archivo '.m--IP/Host String (e.g., ''www.ejemplo.com'' or ''196.77.178.106''.).']);
    end 
    
    if ~isa(mensaje,'int8')
        error([nombre_archivo '.m--Mensaje formato int8']);
    end 
    
elseif accion == RECEIVE    
    
    if ~isnumeric(tamano_paquete) || rem(tamano_paquete,1)~=0 || tamano_paquete < 1
        error([nombre_archivo '.m--Tamano paquete entero positivo.']);
    end 
    
    if ~isnumeric(tiempo_conexion) || tiempo_conexion <= 0
        error([nombre_archivo '.m--Tiempo Debe ser positivo.']);
    end     
    
end 

import java.io.*
import java.net.DatagramSocket
import java.net.DatagramPacket
import java.net.InetAddress

if accion == SEND
    try
        addr = InetAddress.getByName(host);
        packet = DatagramPacket(mensaje, length(mensaje), addr, puerto);
        socket = DatagramSocket;
        socket.setReuseAddress(1);
        socket.send(packet);
        socket.close;
    catch sendPacketError
        try
            socket.close;
        catch closeError
        end 
        
        error('%s.m--Error envio.\nJava error:\n%s',nombre_archivo,sendPacketError.message);
        
    end 
    
else
    try
        socket = DatagramSocket(puerto);
        socket.setSoTimeout(tiempo_conexion);
        socket.setReuseAddress(1);
        packet = DatagramPacket(zeros(1,tamano_paquete,'int8'),tamano_paquete);        
        socket.receive(packet);
        socket.close;
        mensaje = packet.getData;
        mensaje = mensaje(1:packet.getLength);     
        inetAddress = packet.getAddress;
        sourceHost = char(inetAddress.getHostAddress);
        char1 = char(mensaje);
        text=char(sprintf('%s', char1(:)));
        varargout{1} = text;
        
        if nargout > 1
            varargout{2} = sourceHost;
        end 
        
    catch receiveError

        if ~isempty(strfind(receiveError.message,'java.net.SocketTimeoutException'))
            errorStr = sprintf('%s.m--No se pudo recibir paquetes UDP; Excedio el tiempo de conexión.\n',nombre_archivo);
        else
            errorStr = sprintf('%s.m---No se pudo recibir paquetes UDP.\nJava error:\n%s',nombre_archivo,receiveError.message);
        end         

        try
            socket.close;
        catch closeError
        end 

        error(errorStr);
        
    end 
    
end 

