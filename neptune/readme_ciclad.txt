*** Telechargement ***

cd $SCRATCHDIR
git clone https://github.com/aymeric-spiga/dynamico-giant.git

*** Installation ***

cd dynamico-giant
./install.sh

*** Ajout de la variable dans l'environnement

nedit ~/.bashrc
export PATH=$PATH:/home/gmilcareck/dynamico-giant/code/FCM_V1.2/bin
source ~/.bashrc

*** Modification avant compilation ***

Version: svn info

- Version ICOSAGCM: 1055
- Version XIOS: 1944
- Version ICOSA_LMDZ: 2413
- Version IOIPSL: 431
- Version LMDZ: 2413

La version 1055 ICOSAGCM est incompatible avec dynamico. Il faut choisir la version 765. Aucun probleme de compatibilite constate entre cette ancienne version d'ICOSAGCM et les versions recentes de XIOS, ICOSA_LMDZ, IOIPSL, LMDZ

cd code
svn update --revision 765 ICOSAGCM

*** Compilation ***

cd dynamico-giant/saturn
./compile_ciclad.sh

Attention! Il est necessaire d'exporter arch-ifort_CICLAD.path et arch-ifort_CICLAD.env contenu dans dynamico-giant/code/ICOSAGCM/arch dans un dossier arch (qu'il faut creer) situe dans le repertoire dynamico-giant. Il est egalement necessaire de copier arch-ifort_ciclad.fcm dans le repertoire dynamico-giant/code/ICOSA_LMDZ/arch .

Un fichier log_compile se cree meme s'il y a une erreur.

*** Execution ***

Il faut regler les fichiers .xml et .def avant d'executer la simulation.
Modifier run_ciclad. Puis executer:

qsub -l mem=??gb -l vmem=??gb run_ciclad

Creation a la fin des fichiers:
apbp.nc -> coefficient des coordonnees hybrides de la pression
Ai.nc -> Aire de la maille
restart_icosa.nc -> fichier restart.nc
restartfi.nc -> fichier restartfi.nc
Xhistins.nc -> fichier de sortie
xios_client_0.out -> fichier de sortie de xios (normalement vide)
time_counter.nc -> chronometre de la simulation
checkonicosa.txt -> controle les sorties de la simulation
nom_du_test.o#numero_queue_ciclad -> fichier .out de l'execution

En cas d'erreur sur xios, un fichier xios_client_0.err se cree.

*** Description des fichiers ***

apbp.txt: 
Liste des coefficients A et B pour les niveaux de pression. Le nombre de ligne totale du fichier doit etre egal a la resolution verticale.

build_srun_conf.bash:
Il permet de determiner le nombre de noeud, le nombre de coeurs par noeud, le nombre total de coeur pour icosa et le nombre total de coeur pour xios. Le fichier sortie de ce programme est appele par run_occigen (job_mpi). Attention, ce script fonctionne uniquement pour Occigen!

callphys.def:
Meme fichier que sur lmdz.

compile_occigen.sh: 
Fichier de compilation de dynamico pour occigen.

compile_ciclad.sh:
Fichier de compilation de dynamico pour ciclad.

context_lmdz_physics.xml:
Il regle le fichier de sortie de la simulation. Il definit tout d'abord le calendrier. Il est possible de modifier le calendrier dans /home/gmilcareck/dynamico-giant/code/LMDZ.GENERIC/libf/phystd/xios_output_mod.F90 . Il est generalement pas necessaire de le modifier. Il definit ensuite la resolution. dom_glo correspond a la resolution icosahedrique tandis que dom_out correspond a la resolution du fichier de sortie en lon/lat. Il definit ensuite les axes verticaux (pression ou altitude). On definit ensuite la grille. On definit ensuite les variables du fichier de sortie. Pour ajouter de nouvelles variables, elles doivent etre les memes que dans le fichier /home/gmilcareck/dynamico-giant/code/LMDZ_GENERIC/libf/phystd/physiq_mod.F90 . On definit ensuite le fichier de sortie (nom, frequence d'ecriture, type et autorisation de creation du fichier (true,false)) ainsi que les variables qui seront ecrites. ts est le pas de temps physique. Quand output_freq = "40ts" et freq_op=1ts, cela signifie que la fichier est ecrit tous les 40 pas de temps physique et que la variable est calculee tous les pas de temps physique.
On peut egalement definir d'autres fichiers de sortie. Par exemple, diurnalave, qui fait la moyenne des variables.

datadir:
Lien symbolique vers les data files (k-correlees)

diagfi.def:
Fichier vide mais obligatoire

domain_def.xml:
Fichier qui choisit la resolution des fichiers de sortie. ni_glo est le nombre de longitude et nj_glo est le nombre de latitude.

field_def.xml:
Liste des variables de diagnostiques pouvant etre en sortie du fichier de sortie de la simulation mais il faut definir prealablement dans /home/gmilcareck/dynamico-giant/code/LMDZ_GENERIC/libf/phystd/physiq_mod.F90 celles qui ne sont pas presentes dans ce fichier physiq_mod.F90. Les variables de ce fichier sont generalement utilise par les terrestres et on peut les faire sortir avec precast.nc donc le fichier n'est pas tres utile.

gases.def:
Meme fichier que sur lmdz. Liste des gaz avec leur concentration (%).

icosa.xml:
Le fichier definit les fichiers start et restart. Il definit egalement les differents types d'axes: lev (hybrid level at midpoints), levp1 (hybrid level at interface), lev_pressure, nq (?), lev_ecdyn (?); les differents types de domaine: i, from_relief, from_ecdyn, v, u, domain_relief, domain_ecdyn, dom_out; les differents type de grille: scalar, grid_q; qu'on peut utiliser sur dynamico. Pas de modification a faire sur le fichier.

iodef.xml:
Il realise la repartition des calculs et de l'ecriture sur des processeurs. Par defaut, print_file = true et using_server = false. Pas besoin de modifier.
Il appelle les fichiers icosa.xml et context_lmdz_physics.xml pour XIOS. Il est au sommet de l'arborescence des fichiers .xml.

job_mpi:
Fichier d'execution sur occigen.

run.def:
Il reunit les fichiers des constantes (saturn_const.def), run_icosa.def et callphys.def.
Attention, on definit le pas de temps physique mais sous un autre nom (iphysiq). Il faut qu'il soit egal au itau-physics de run_icosa.def .

run_icosa.def:
Fichiers qui permet de regler les parametre de l'icosahedre, le temps, la dynamique, la physique, la dissipation.
Il faut inclure le fichier saturn_const.def.

run_cilad:
Fichier d'execution du ciclad.

saturn_const.def:
Liste des constantes propres a la planete et necessaire a la simulation.

traceur.def:
Par defaut (sans traceur), il y a a l'interieur du fichier:
1
dummy

*** callphys.def ***

tracer = .true. (toujours)
Ne pas modifier datadir ici dans le fichier, il faut le modifier dans le lien symbolique.
Rajouter le code de Jan pour les nuages.


*** run_icosa.def ***

nbp = sqrt(nbr_lat x nbr_lon / 10 ) Il faut prendre le multiple de 10 le plus proche.
nombre de processeurs = 10 x nsplit_i x nsplit_j
nbp/nsplit{i,j} >~ 10

itau_physics = iphysiq
Pas de temps dynamique: dt = write_period = (duree d'un jour en s) / (day_step sur LMDZ)
Pas de temps physique: 1 ts = dt x itau_physics

itau_adv /ts
itau_check_conserv /ts


*** Liste des fichiers a modifier CICLAD ***
compile_ciclad.sh (si necessaire)
apbp.txt (si necessaire)
datadir (si necessaire)
gases.def (si necessaire)
callphys.def
domain_def.xml
run_icosa.def
run.def
context_lmdz_physics.xml
run_ciclad

*** Liste des fichiers a modifier OCCIGEN ***
compile_occigen.sh (si necessaire)
apbp.txt
build_srun_conf.bash
callphys.def
context_lmdz_physics.xml
datadir
domain_def.xml
gases.def
job_mpi
run.def
run_icosa.def

*** Liste des fichiers a modifier CICLAD 1D ***
compile_ciclad.sh (si necessaire)
callphys.def
compile_ciclad.sh
datadir
gases.def
rcm1d.def
run_ciclad
z2sig.def
