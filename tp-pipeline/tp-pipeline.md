# Mise en place d'un pipeline avec CodePipeline, CodeBuild et Cloud formation

Cet exercice permet de créer un pipeline à partir d'un template Cloud Formation. Mais aussi de builder une application en nodeJS et de la déployer.
Il a pour objects :
* de créer et d'utiliser un dépôt Code Commit
* de créer un template CloudFormation
* de mettre en place un pipeline avec CodePipeline
* d'automatiser le build de son code avec CodeBuild et CodePipeline
* de déployer son application en serverless dans Lambda 

Durée : entre 60 et 90 minutes

## Pré-requis
* Sur une instance EC2, ou sur votre poste, installer la version 2 la CLI AWS : 
https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/cli-chap-install.html
* Installer git :
https://git-scm.com/book/fr/v2/D%C3%A9marrage-rapide-Installation-de-Git
* Avoir un compte AWS et des accès à la CLI (via une clé d'accès et une secret access key)
* Configurer la connexion avec la commande :
```
aws configure
```

## Mise en place de l'environnement de travail 
* Créer un dossier pour ce nouveau projet et se mettre dedans:
```
mkdir codepipeline
cd codepipeline
```
* Cloner le dépôt pour récupérer le code :
```
git clone https://github.com/widdix/learn-codepipeline.git
```
* Créer un dépôt sur AWS CodeCommit (remplacer dans la commande $user par votre nom)
```
aws codecommit create-repository --repository-name learn-codepipeline-$user
```
* La commande renvoit un résultat ressemblant à : 
```
{
    "repositoryMetadata": {
        "accountId": "111111111111",
        "repositoryId": "c1998fd8-2c78-4a73-984c-53d588a6b237",
        "repositoryName": "learn-codepipeline-andreas",
        "lastModifiedDate": 1541665280.947,
        "creationDate": 1541665280.947,
        "cloneUrlHttp": "https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/learn-codepipeline-andreas",
        "cloneUrlSsh": "ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/learn-codepipeline-andreas",
        "Arn": "arn:aws:codecommit:eu-west-1:111111111111:learn-codepipeline-andreas"
    }
}
```
* Executer la commande suivante pour ajouter le nouveau dépôt distant, en remplaçant $cloneUrlHttp par sa valeur à récupérer dans la sortie de la commande précédente :
```
git remote add deploy $cloneUrlHttp
```
* Modifier le fichier .git/config et ajouter à l'intérieur :
```
[credential]
    helper =
    helper = !aws codecommit credential-helper $@
    UseHttpPath = true
```
* Puis déployer votre code :
```
git push deploy master
```
-> Votre environnement est maintenant prêt et votre code sur le dépôt git AWS CodeCommit

## Mise en place du Pipeline
* Récupérer le template de départ pour la création du pipeline :
```
cp lab01-cloudformation/starting-point/pipeline.yml deploy/pipeline.yml
```
* Dans la section Resources du template : ajouter un bucket :
```
  ArtifactsBucket:
    DependsOn: CloudFormationRole # make sure that CloudFormationRole is deleted last
    DeletionPolicy: Retain
    Type: 'AWS::S3::Bucket'
```
* Dans la section Resources du template, ajouter un pipeline :
```
Pipeline:
    Type: 'AWS::CodePipeline::Pipeline'
    Properties:
      ArtifactStore:
        Type: S3
        Location: !Ref ArtifactsBucket
      Name: !Ref 'AWS::StackName'
      RestartExecutionOnUpdate: true
      RoleArn: !GetAtt 'PipelineRole.Arn'
      Stages:
      - Name: Source
        Actions:
        - Name: FetchSource
          ActionTypeId:
            Category: Source
            Owner: AWS
            Provider: CodeCommit
            Version: 1
          Configuration:
            RepositoryName: !Ref RepositoryName
            BranchName: !Ref BranchName
          OutputArtifacts:
          - Name: Source
          RunOrder: 1
      - Name: Pipeline
        Actions:
        - Name: DeployPipeline
          ActionTypeId:
            Category: Deploy
            Owner: AWS
            Provider: CloudFormation
            Version: 1
          Configuration:
            ActionMode: CREATE_UPDATE
            Capabilities: CAPABILITY_IAM
            RoleArn: !GetAtt 'CloudFormationRole.Arn'
            StackName: !Ref 'AWS::StackName'
            TemplatePath: 'Source::deploy/pipeline.yml'
            ParameterOverrides: !Sub '{"RepositoryName": "${RepositoryName}", "BranchName": "${BranchName}"}'
          InputArtifacts:
          - Name: Source
          RunOrder: 1
```
** Ce pipeline récupère les sources sur le dépôt CodeCommit 
** Puis il déploit le template sur le bucket S3.
* Créer la stack CloudFormation à partir du template, en remplaçant $user par votre nom :
```
aws cloudformation create-stack --stack-name learn-codepipeline-$user --template-body file://deploy/pipeline.yml --parameters ParameterKey=RepositoryName,ParameterValue=learn-codepipeline-$user --capabilities CAPABILITY_IAM
```
* Le pipeline échoue, puisque vous n'avez pas encore déployer de changement. Pour ajouter le fichier au dépôt git et le déployer :
```
git add deploy/pipeline.yml
git commit -m "lab 01"
git push deploy master
```
-> Cette fois le pipeline doit fonctionner, félicitation, votre pipeline est en place.

## Ajouter le build d'une application 



## Nettoyage
Make sure you are deleting all the resources created while going through the labs.

Delete the CodeCommit repository learn-codepipeline-$user.
Got to the CloudFormation stack learn-codepipeline-$user and note down the name of the S3 bucket with the logical ID ArtifactsBucket.
Delete the CloudFormation stack learn-codepipeline-$user.
Delete the S3 bucket you noted down before deleting the CloudFormation stack.

