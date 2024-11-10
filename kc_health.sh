
echo "Waiting for Keycloak to be ready..."
until [ "$(curl -o /dev/null -s -w '%{http_code}' http://localhost:8080)" -eq 200 ]; do
    sleep 5
    echo "Keycloak is still starting up..."
done
echo "Keycloak is ready!"
