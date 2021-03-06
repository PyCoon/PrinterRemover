
#
# Fonction Graphique Powershell permettant de générer une fenêtre et une checkbox pour cdhaque imprimante trouvée sur le systême. Le click sur le bouton "Supprimer"
# supprimera les imprimantes selectionnées.
#


#----------------------------------------------
# Début de la fonction Principale
#----------------------------------------------

function GenerateForm {

[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

$printesrObj = Get-WmiObject -Class Win32_Printer
$nbPrinterObj = $printesrObj | measure
$nbPrinter = $nbPrinterObj.Count
$form1 = New-Object System.Windows.Forms.Form
$button1 = New-Object System.Windows.Forms.Button
$listBox1 = New-Object System.Windows.Forms.ListBox

$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState

$b1= $false
$b2= $false
$b3= $false

#----------------------------------------------
# Génération des gestionnaires d'événements
#----------------------------------------------

# Lors de l'appui sur le bouton "Supprimer"


$handler_button1_Click=
{
    # Nettoyage de la Boite de liste, récupération des objets printers et de leurs checkboxes associées.
    $listBox1.Items.Clear();
    $listOfCheckboxes.GetEnumerator() | % {
    $chuName = $_.key
    $checkbox = $_.value[0]
    $printer = $_.value[1]

    # Si la checkbox est cochée, suppression de l'objet associé.
    if ($checkbox.Checked)     {
    $deletionTried = "TRUE"
    Try{
    $printer.Delete()
    $listBox1.Items.Add( "  $chuName :: est supprimée."  )
        }
    Catch {
    $listBox1.Items.Add( "  $chuName :: echec de suppression !"  )
        }


    $form1.controls.Remove($checkbox)

    }

    }



}

$OnLoadForm_StateCorrection=
{#Corrige le form1 pour éviter l'apparition d'un buig d'affichage.
    $form1.WindowState = $InitialFormWindowState
}

#----------------------------------------------
#Déclaration des objets graphiques.
#----------------------------------------------

# Fenêtre principale
$form1.Text = "Printer Remover Tool"
$form1.Name = "form1"
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 650
# Ajustement de la la hauteur du form
$System_Drawing_Size.Height = ($nbPrinter * 45) + 90
$form1.ClientSize = $System_Drawing_Size


# Bouton Supprimer
$button1.TabIndex = 4
$button1.Name = "button1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$button1.Size = $System_Drawing_Size
$button1.UseVisualStyleBackColor = $True

$button1.Text = "Supprimer"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 27
# Ajustement de la la position du boutton.
$System_Drawing_Point.Y = ($nbPrinter * 45) +60
$button1.Location = $System_Drawing_Point
$button1.DataBindings.DefaultDataSourceUpdateMode = 0
$button1.add_Click($handler_button1_Click)

$form1.Controls.Add($button1)

# Ajout de la liste d'affichage

$listBox1.FormattingEnabled = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 400
# Ajustement de la la hauteur de la liste d'afichage
$System_Drawing_Size.Height = ($nbPrinter * 45) +40
$listBox1.Size = $System_Drawing_Size
$listBox1.DataBindings.DefaultDataSourceUpdateMode = 0
$listBox1.Name = "listBox1"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 237
$System_Drawing_Point.Y = 43
$listBox1.Location = $System_Drawing_Point
$listBox1.TabIndex = 3

$form1.Controls.Add($listBox1)

# Création des checkboxes.

# Initialisation de la position verticale de la première checkbox
$y = 43

$listOfCheckboxes = @{}
foreach ($obj in $printesrObj) {


    $checkBox1 = New-Object System.Windows.Forms.CheckBox
    $checkBox1.UseVisualStyleBackColor = $True
    $System_Drawing_Size = New-Object System.Drawing.Size

    $System_Drawing_Size.Width = 124
    $System_Drawing_Size.Height = 44
    $checkBox1.Size = $System_Drawing_Size
    $checkBox1.TabIndex = 0
    $name = $obj.Name
    $server = $obj.SystemName
    $checkBox1.Text = "$name ; $server"
    $System_Drawing_Point = New-Object System.Drawing.Point

    $System_Drawing_Point.X = 27
    $System_Drawing_Point.Y = $y
    # Incrémentation du positionnement vertical des checkboxes.
    $y += 45
    $checkBox1.Location = $System_Drawing_Point
    $checkBox1.DataBindings.DefaultDataSourceUpdateMode = 0
    $chuName =  "\\$server\$name"
    $checkBox1.Name = $chuName

    $listOfCheckboxes.Add( $chuName , @( $checkBox1, $obj) )
    $form1.Controls.Add( $checkBox1)

}

# Creation Label.

$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Ce programme permet de supprimer les files d'imprimantes selectionnées.`nFonctionne pour tous les utilisateurs si lancé comme administrateur."
$Label.AutoSize = $True
$System_Drawing_Point.X = 5
$System_Drawing_Point.Y = 5
$Label.Location = $System_Drawing_Point
$form1.Controls.Add($Label)



#Sauvegarde de l'état initial du form1
$InitialFormWindowState = $form1.WindowState
#Initialisation de l'evenement OnLOad.
$form1.add_Load($OnLoadForm_StateCorrection)


 #Affichage du form
 $form1.ShowDialog()| Out-Null
} #Fin de fonction GenerateForm

#Appel de la fonction
GenerateForm


