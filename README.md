## Proyecto
Nombres:
   Laura Tatiana Bernal Yanquen
   Daniel Yesid Casallas Páez
## Problemas Identificados

### Personas
- Algunas personas tienen número de documento repetido
- Solución temporal: Se asignaron identificadores temporales que posteriormente serán reemplazados por el número de documento correcto

### Artículos
- La mayoría de artículos tienen el mismo nombre
- Solución implementada:
    - Sumar todas las cantidades
    - Promediar los precios
    - Crear un mapeo de IDs (clave-valor): nueva ID → IDs antiguos
    - Utilizar este mapeo para actualizar las referencias en ventas

### Ventas
- Reemplazar los IDs de artículos según el mapeo clave-valor
- Actualizar números de documento en caso de duplicados

## Estado del Proyecto
⚠️ **Nota:** El proyecto está en desarrollo. Pendiente: normalización del ETL.


## Comandos Docker
```
docker exec -it name bash
```
```
docker ps
```
```
docker ps -a
```
```
docker nework ls 
```

## Comandos mongoDB
```
mogosh
```
```
db.collection.find()
```

## Comandos SQLITE
Entrar a la bd

```
sqlite3 almacen.sqlite
```

Mostrar Tablas

```
.tables
```