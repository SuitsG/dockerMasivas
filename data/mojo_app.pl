use Mojolicious::Lite;
use DBI;
use MongoDB;
use JSON;
use File::Slurp;
use Data::Dumper;
use Mojo::JSON qw(decode_json);
use Mojo::UserAgent;

 
 
# Conectar a la base de datos SQLite
my $db = DBI->connect("dbi:SQLite:dbname=/app/data/almacen.sqlite", "", "", {
    RaiseError => 1,
    AutoCommit => 1,
    sqlite_unicode => 1,
}) or die "No se pudo conectar a la base de datos SQLite: $DBI::errstr";
 
# Conectar a MongoDB para cada colección en sus respectivos contenedores
my $mongo_personas = MongoDB->connect('mongodb://mongodb_personas:27017');
my $mongo_articulos = MongoDB->connect('mongodb://mongodb_articulos:27017');
my $mongo_ventas = MongoDB->connect('mongodb://mongodb_ventas:27017');
 
# Función para cargar datos desde archivos JSON a MongoDB
sub load_data_to_mongo {
    my ($json_file_path, $container_name) = @_;
   
    eval {
        # Leer el archivo JSON
        my $json_text = read_file($json_file_path);
        my $data = decode_json($json_text);
       
        # Seleccionar la colección según el contenedor usando las conexiones existentes
        my $collection;
       
        if ($container_name eq 'personas') {
            $collection = $mongo_personas->get_database('persona')->get_collection('person');
        } elsif ($container_name eq 'articulos') {
            $collection = $mongo_articulos->get_database('articulo')->get_collection('article');
        } elsif ($container_name eq 'ventas') {
            $collection = $mongo_ventas->get_database('venta')->get_collection('sales');
        } else {
            die "Contenedor desconocido: $container_name";
        }
       
        # Insertar datos
        if (ref($data) eq 'ARRAY') {
            $collection->insert_many($data);
        } else {
            $collection->insert_one($data);
        }
       
        log_debug("Datos cargados exitosamente desde $json_file_path al contenedor $container_name");
        return 1;
    };
   
    if ($@) {
        log_debug("Error al cargar datos: $@");
        return 0;
    }
}


 
# Función para registrar mensajes de depuración
sub log_debug {
    my ($message) = @_;
    my $log_file = '/app/data/debug.log';  # Especifica la ruta completa al archivo de log
    open my $fh, '>>', $log_file or die "No se puede abrir el archivo: $!";
    print $fh localtime() . " - $message\n";  # Incluye timestamp
    close $fh;
}
 
 
# Función para extraer y cargar personas
sub etl_process_personas {
   
}
 
 
# Función para extraer y cargar artículos
sub etl_process_articulos {
 
}
 
# Función para extraer y cargar ventas
sub etl_process_ventas {
 
}
 
# Endpoint POST
post '/etl' => sub {
   
};

get '/etl' => sub {
    my $c = shift;
    
    # Ejecutar en segundo plano
    system('python etl_paralelo.py &');
    
    $c->render(text => 'ETL iniciado en segundo plano');
};

# Rutas para cargar datos
get '/load_data' => sub {
    my $c = shift;
   
    eval {
        load_data_to_mongo('/app/data/personas.json', 'personas');
        load_data_to_mongo('/app/data/articulos.json', 'articulos');
        load_data_to_mongo('/app/data/ventas.json', 'ventas');
       
        $c->render(json => { success => 1, message => "Datos cargados" });
    };
   
    if ($@) {
        $c->render(json => { error => $@ }, status => 500);
    }
};
 
# Rutas para obtener datos de MongoDB
get '/mongo/personas' => sub {
    my $c = shift;
    eval {
        my $collection = $mongo_personas->get_database('persona')->get_collection('person');
        my @personas = $collection->find->all;
        $c->render(json => \@personas);
    };
 
    if ($@){
        $c->render(json => { error => "Error al obtener personas: $@" }, status => 500);
    }
};
 
get '/mongo/articulos' => sub {
    my $c = shift;
    eval {
        my $collection = $mongo_articulos->get_database('articulo')->get_collection('article');
        my @articulos = $collection->find->all;
        $c->render(json => \@articulos);
    };
 
    if ($@){
        $c->render(json => { error => "Error al obtener artículos: $@" }, status => 500);
    }
};
 
get '/mongo/ventas' => sub {
    my $c = shift;
    eval {
        my $collection = $mongo_ventas->get_database('venta')->get_collection('sales');
        my @ventas = $collection->find->all;
        $c->render(json => \@ventas);
    };
 
    if ($@){
        $c->render(json => { error => "Error al obtener ventas: $@" }, status => 500);
    }
};
 
# Rutas para obtener datos de SQLite
get '/sqlite/personas' => sub {
    my $c = shift;
   
    eval {
        my $sth = $db->prepare("
        SELECT
        numeroDocumento,
        nombres,
        primerApellido,
        segundoApellido,
        fechaNacimiento,
        telefono,
        direccion,
        email
        FROM
        personas");
        $sth->execute();
        my @personas;
        while (my $row = $sth->fetchrow_hashref) {
            push @personas, $row;
        }
        $c->render(json => \@personas);
    };
   
    if ($@) {
        $c->render(json => { error => "Error al obtener personas: $@" }, status => 500);
    }
};
 
get '/sqlite/articulos' => sub {
    my $c = shift;
   
    eval {
        my $sth = $db->prepare("SELECT
        idArticulo,
        nombreArticulo,
        precioArticulo,
        cantidadArticulo
        FROM
        articulos");
        $sth->execute();
        my @articulos;
        while (my $row = $sth->fetchrow_hashref) {
            push @articulos, $row;
        }
        $c->render(json => \@articulos);
    };
   
    if ($@) {
        $c->render(json => { error => "Error al obtener artículos: $@" }, status => 500);
    }
};
 
get '/sqlite/ventas' => sub {
    my $c = shift;
   
    eval {
        my $sth = $db->prepare("
        SELECT
        idVenta,
        idComprador,
        idArticulo,
        cantidadProductos,
        precioTotal
        FROM
        ventas");
        $sth->execute();
        my @ventas;
        while (my $row = $sth->fetchrow_hashref) {
            push @ventas, $row;
        }
        $c->render(json => \@ventas);
    };
   
    if ($@) {
        $c->render(json => { error => "Error al obtener ventas: $@" }, status => 500);
    }
};
 
# Agregar una nueva persona
post '/sqlite/personas' => sub {
    my $c = shift;
   
    eval {
        my $data = $c->req->json;
       
        my $sth = $db->prepare("
            INSERT INTO personas (
                numeroDocumento,
                nombres,
                primerApellido,
                segundoApellido,
                fechaNacimiento,
                telefono,
                direccion,
                email
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ");
       
        $sth->execute(
            $data->{numeroDocumento},
            $data->{nombres},
            $data->{primerApellido},
            $data->{segundoApellido},
            $data->{fechaNacimiento},
            $data->{telefono},
            $data->{direccion},
            $data->{email}
        );
       
        $c->render(json => { success => 1, message => "Persona agregada exitosamente" });
    };
   
    if ($@) {
        $c->render(json => { error => "Error al agregar persona: $@" }, status => 500);
    }
};
 
# Agregar un nuevo artículo
post '/sqlite/articulos' => sub {
    my $c = shift;
   
    eval {
        my $data = $c->req->json;
        
        my $sth = $db->prepare("
            INSERT INTO articulos (
                idArticulo,
                nombreArticulo,
                precioArticulo,
                cantidadArticulo
            ) VALUES (?, ?, ?, ?)
        ");

        $sth->execute(
            $data->{idArticulo},
            $data->{nombreArticulo},
            $data->{precioArticulo},
            $data->{cantidadArticulo}
        );

        $c->render(json => {
            success => 1,
            message => "Artículo agregado exitosamente"
        });
    };
   
    if ($@) {
        $c->render(json => { error => "Error al agregar artículo: $@" }, status => 500);
    }
};
 
# Agregar una nueva venta
post '/sqlite/ventas' => sub {
    my $c = shift;
   
    eval {
        my $data = $c->req->json;
       
        my $sth = $db->prepare("
            INSERT INTO ventas (
                idVenta,
                idComprador,
                idArticulo,
                cantidadProductos,
                precioTotal
            ) VALUES (?, ?, ?, ?, ?)
        ");
       
        $sth->execute(
            $data->{idVenta},
            $data->{idComprador},
            $data->{idArticulo},
            $data->{cantidadProductos},
            $data->{precioTotal}
        );
       
        $c->render(json => { success => 1, message => "Venta agregada exitosamente" });
    };
   
    if ($@) {
        $c->render(json => { error => "Error al agregar venta: $@" }, status => 500);
    }
};
 
 
# Iniciar la aplicación Mojolicious
app->start;