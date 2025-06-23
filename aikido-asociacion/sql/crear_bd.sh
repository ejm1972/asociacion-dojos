docker cp aikido-asociacion/sql/esquema.sql aikido_db:/esquema.sql
docker exec -i aikido_db mysql -u root -proot aikido < /esquema.sql
