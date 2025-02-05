deployment_file="00_deployment.yaml"

echo "Inicializando variables de entorno..."

#Apache
export APACHE_PORT_WEB=$(yq e '.apache.port_web' $deployment_file)
export APACHE_PORT_SSL=$(yq e '.apache.port_ssl' $deployment_file)

#Proxy configuration
export PROXY_NAME=$(yq e '.proxy.name' $deployment_file)
export PROXY_NET=$(yq e '.proxy.network' $deployment_file)
export PROXY_WEB_PORT=$(yq e '.proxy.port_web' $deployment_file)
export PROXY_SSL_PORT=$(yq e '.proxy.port_ssl' $deployment_file)
export PROXY_ADM_PORT=$(yq e '.proxy.port_admin' $deployment_file)

#Output
echo $APACHE_PORT_WEB
echo $APACHE_PORT_SSL
echo $PROXY_NAME
echo $PROXY_NET
echo $PROXY_WEB_PORT
echo $PROXY_SSL_PORT
echo $PROXY_ADM_PORT