# Utilisation de l'outil de Well Architected Framework

Cet exercice permet d'utiliser l'outil permettant de vérifier le respect du Well Architected Framework.
Il a pour objectifs :

* De créer un **workload**
* D'effectuer une revue
* D'enregistrer des étapes 
* D'afficher et de télécharger le rapport généré

## Aller dans le service de AWS Well Architected tool avec la console web
* Se connecter à la console web d'AWS
* Dans le menu Services, chercher  **Well Architected**  et cliquer sur  **AWS Well-Architected Tool**:  
![Select WAT](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT0.png)


## Créer une charge de travail 
Les revues de Well-Architected sont menées par  [workload(charge de travail)](https://wa.aws.amazon.com/wat.concept.workload.en.html). Une charge de travail identifie une série de composants qui délivre de la valeur métier. La charge de travail est généralement le niveau de détail que les managers et les leaders techniques utilise comme niveau d'échange.

* Cliquer sur **Define Workload** :
![ClickWorkload](https://github.com/setheliot/aws-well-architected-labs/tree/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT1.png)
* Si des charges de travails existes, vous verrez alors la liste apparaitre. Pour en créer une nouvelle cliquer sur le bouton  **Define Workload** :
![ClickWorkload2](https://github.com/setheliot/aws-well-architected-labs/tree/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT2.png)
* Dans l'interface de définition de la charge de travail entrer les informations nécessaires :
![EnterWorkloadDetails](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT3.png)
- Name: Workload Prenom Example  
- Description: Exemple d'utilisation des workload
- Industry Type: InfoTech  
- Industry: Internet  
- Environment: Select "Pre-production"  
- Regions: Sélectionner une région AWS par exemple : US West (Oregon)/us-west-2  
* Cliquer sur  **Define workload** :
![DefineWorkload](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT4.png)

## Effectuer une revue 
* Dans la page de détail de la charge de travail, cliquer sur le bouton **Start review** :
![StartingReview](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT5.png)  
* Pour l'exemple, on ne complète que les queston liée au pilier sur la Fiabilité. Fermer la partier sur l'Excellence opérationnelle en cliquant sur le bouton de fermeture à gauche :
![CollapseOE](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT6.png)
* Etendre les questions sur la Reliabilité en cliquant sur l'icone d'expansion à gauche du mot **Fiabilité(Reliability)** :
![ExpandReliability](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT7.png)
* Séléctionner la première question **REL 1. How do you manage service limits?**
![SelectREL1](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT8.png)
* Répondre aux questions 1 à 9. Utiliser le lien 
 **Info** pour mieux comprendre le sens des réponses et voir les vidéos qui expliquent le contexte des questions.
![InfoAndVideo](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT9.png)
* Après avoir compléter les questions, sélectionner le bouton **Next** en bas de la page de réponse :
![SelectNext](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT10.png)
* Après avoir répondre à la dernière question sur la reliabilité, cliquer sur  **Save and Exit:** 
![SelectSave](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT11.png)

## Définir des jalons (milestone)
* Sur la page de détail de la charge de travail cliquer sur **Save milestone**:
![SavingMilestone](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT12.png)  
* Entrer un nom pour le jalon comme **Demo Jalon** et cliquer sur **Save** :
![EnterMilestoneName](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT13.png)
* Cliquer sur l'onglet **Milestones** :
![ViewMilestones](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT14.png)
* Cela affiche les jalons et les données à propos des jalons:
![ListMilestones](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT15.png)

## Voir et télécharger le rapport
* Depuis la page de détail de la charge de travail, cliquer sur l'onglet **Improvement Plan** :
![ViewImprovementPlan](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT16.png)  
* Cela affiche le nombre de risques hauts et moyens et vour permet de mettre à jour le statut d'amélioration:
![UpdateImprovementStatus](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT17.png)
* Vous pouvez aussi modifier la configuration du plan d'amélioration. Cliquer sur le bouton  **Edit** :
![EditImprovementPlanConfig](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT18.png)
* Remonter le pillier de la Fiabilité en haut en cliqunt sur l'icone flèche vers le haut, ou en glisser déposer :
![RaiseReliability](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT19.png)
* Cliquer sur le bouton **Save** pour enregistrer la configuration :
![SaveConfig](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT20.png)
* Cliquer sur l'onglet Aperçu, dans la section Filtre, sélectionner votre examen :
![SelectReview](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT21.png)
* Cliquer sur le bouton  **Generate report** pour générer et télécharge le rapport:
![SelectGenerateReport](https://github.com/setheliot/aws-well-architected-labs/blob/master/Well-ArchitectedTool/100_Walkthrough_of_the_Well-Architected_Tool/Images/AWSWAT22.png)
* Vous pouvez ouvrir le fichier ou le sauvegarder pour plus tard.

## Pour aller plus loin

VOus pouvez trouvez de nombreux exercices autour de Well Architected framework dans ce labs (en anglais ) : 
https://wellarchitectedlabs.com/ 
