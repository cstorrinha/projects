<!DOCTYPE html>
<html lang="en">
<head>

    <link rel="stylesheet" href="css/geral.css"> <!-- css externo: aplicar uma "regra" à nossa página usando um ficheiro externo -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>O meu Website</title>

<!-- css interno: quer dizer que vai aplicar o mesmo estilo a todas as tag "td" que encontrar  -->
    <style> 
        td {
                background-color: grey;
                color: black;
        }
    </style>

</head>
<body>
    <header>
        <nav>
            <ul>
               <li> <a href="#home">Home</a></li>
               <li> <a href="#menu1">Menu 1</a></li>
               <li> <a href="#menu2">Menu 2</a></li>       
            </ul>
        </nav>

        <h1> Os meus clientes</h1>
     
    <table border =1>

<!-- isto é um comentário -->
       
           <tr> <!-- tr = table row = linhas da tabela -->
                <!-- <td style = "color:red" </td>>Nome</td>  td = table data = célula > isto é o css inline, directamente dentro da tag -->
                <td>Nome</td> 
                <td>Morada</td>
                <td>Email</td>
                <td>Telefone</td>
                <td>Código Postal</td>
                <td>Localidade</td>
           </tr> 
    </table>

        <h2>Uma imagem que eu gosto</h2>
            <img src="http://unsplash.it/1400/400" alt="Imagem de exemplo"> <!-- alt = accessibilidade, é o que iria aparecer
            se a imagem não aparecesse-->

    <div class="classe1"> <!-- como usar o css externo: através da Classe ou Id. Quando são classes usamos o "." Para os Ids usamos o # -->

        <span id="id1"> Isto é apenas um texto para vermos o CSS a funcionar. </span>

    </div>

       <?php 

        echo "Isto á uma frase escrita em PHP";

        ?>


    <?php
$nome = $_POST['nome'] ?? '';
?>

<form method="POST">
    <input type="text" name="nome" placeholder="Digite seu nome">
    <button type="submit">Enviar</button>
</form>

<?php if ($nome): ?>
    <p>Olá, <?= htmlspecialchars($nome) ?>!</p>
<?php endif; ?>


    </header>

<main>

 <?php
// $host = 'sql7.freesqldatabase.com';   // Host correto fornecido pelo site
// $db   = 'sql7786660';                   // Nome da base de dados correto
// $user = 'sql7786660';                   // Nome de utilizador
// $pass = 'mWP4i728HB';      // Senha atribuída
// $port = 3306;

// $conn = new mysqli($host, $user, $pass, $db, $port);

// if ($conn->connect_error) {
   // die("Erro na conexão: " . $conn->connect_error);
// }

echo "Ligação à BD bem feita!";
 ?>

<?php
// Dados da conexão
$serverName = "CTORRINHA-7320\SQLCESAE"; // Atenção à dupla barra \\
$connectionOptions = array(
    "Database" => "Northwind",    // Substitui pelo nome da tua BD
    "TrustServerCertificate" => true,
);

// Conexão
$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
}
?>
// Apagar o registo


        <form action="index.php" method="POST">
            <label for="id">ID a apagar:</label>
            <input type="text" name="id" id="id" required>
            <input type="submit" value="Eliminar">
        </form>;

<?php
        // Processamento do pedido de eliminação
        if (isset($_POST['id'])) {
            $id = $_POST['id'];

            $sql = "DELETE FROM Employees WHERE EmployeeID = ?";
            $params = array($id);

            $stmt = sqlsrv_query($conn, $sql, $params);

            if ($stmt === false) {
                echo "<br>Erro ao eliminar o registo:<br>";
                print_r(sqlsrv_errors(), true);
            } else {
                echo "<br>Registo eliminado com sucesso.";
                echo "<br><a href='indexnovo.php'>Voltar à página principal</a>";
                echo "<br><a href='apagar.php'>Voltar à janela anterior</a>";
            }

            sqlsrv_free_stmt($stmt);
        }
        


// Query
$query = "SELECT TOP 5 EmployeeID, FirstName, Address, City, PostalCode FROM Employees";
$result = sqlsrv_query($conn, $query);

if ($result === false) {
    die(print_r(sqlsrv_errors(), true));
}

// echo "<table border='1' cellpadding='8' cellspacing='0'>"; tr = linha
echo "<table border='1' cellpadding= '0' cellspacing= '2'>";
echo "<tr> 
        <th>EmployeeID</th> 
        <th>FirstName</th>
        <th>Address</th>
        <th>City</th>
        <th>PostalCode</th>
      </tr>";

$rows_found = false;

while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) { // enquanto existirem linhas, vamos imprimir a abertura e fecho das linhas
    $rows_found = true;
    echo "<tr>";
    echo "<td>" . htmlspecialchars($row["EmployeeID"]) . "</td>";
    echo "<td>" . htmlspecialchars($row["FirstName"]) . "</td>";
    echo "<td>" . htmlspecialchars($row["Address"]) . "</td>";
    echo "<td>" . htmlspecialchars($row["City"]) . "</td>";
    echo "<td>" . htmlspecialchars($row["PostalCode"]) . "</td>";
    echo "</tr>";
}

echo "</table>";

if (!$rows_found) {
    echo "Não há valores a mostrar";
}



?>

</main>

</body>
</html>