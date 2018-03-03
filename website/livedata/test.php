<?php 

require_once("./db/dbconnect.php");

$localinoSQL = "SELECT zeit,tag,x,y,z FROM tbl_positions ORDER by tbl_positions.zeit DESC LIMIT 10";

?>

<!DOCTYPE html>
<html>
<head>
	
</head>
<body>

<table id="localinoTable" class="responsive-table highlight" style="border: 1px solid black;">
	<thead style="border: 1px solid black;">
		<tr style="border: 1px solid black;">
		<th style="border: 1px solid black;">Time</th>
		<th style="border: 1px solid black;">Day</th>
		<th style="border: 1px solid black;">X</th>
		<th style="border: 1px solid black;">Y</th>
		<th style="border: 1px solid black;">Z</th>
		</tr>
	</thead>

	<tbody style="border: 1px solid black;">
		<?php
		$filter_results = $pdo->query($localinoSQL);

		if($filter_results->rowCount() == 0) {
		echo '<tr><td>No results...</td><td></td></tr>';
		}
		else {
			foreach ($filter_results as $row) {
			echo '<tr style="border: 1px solid black;">';
			echo '<td style="border: 1px solid black;">'.$row['zeit'].'</td>';
			echo '<td style="border: 1px solid black;">'.$row['tag'].'</td>';
			echo '<td style="border: 1px solid black;">'.$row['x'].'</td>';
			echo '<td style="border: 1px solid black;">'.$row['y'].'</td>';
			echo '<td style="border: 1px solid black;">'.$row['z'].'</td>';
			echo '</tr>';

			}
		}
	?>
	</tbody>
</table>

</body>
</html>