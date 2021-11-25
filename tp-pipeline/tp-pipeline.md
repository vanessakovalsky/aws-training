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
* Dans le fichier de template, ajouter le rôle pour CodeBuild :
```
  CodeBuildRole:
    DependsOn: CloudFormationRole # make sure that CloudFormationRole is deleted last
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
        - Effect: Allow
          Principal:
            Service:
            - 'codebuild.amazonaws.com'
          Action:
          - 'sts:AssumeRole'
      Policies:
      - PolicyName: ServiceRole
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
          - Sid: CloudWatchLogsPolicy
            Effect: Allow
            Action: 
            - 'logs:CreateLogGroup'
            - 'logs:CreateLogStream'
            - 'logs:PutLogEvents'
            Resource: '*'
          - Sid: CodeCommitPolicy
            Effect: Allow
            Action: 'codecommit:GitPull'
            Resource: '*'
          - Sid: S3GetObjectPolicy
            Effect: Allow
            Action: 
            - 's3:GetObject'
            - 's3:GetObjectVersion'
            Resource: '*'
          - Sid: S3PutObjectPolicy
            Effect: 'Allow'
            Action: 's3:PutObject'
            Resource: '*'
```
* Puis ajouter à la section Resources, avant le Pipeline le projet CodeBUild :
```
  AppProject:
    DependsOn: CloudFormationRole # make sure that CloudFormationRole is deleted last
    Type: 'AWS::CodeBuild::Project'
    Properties:
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        ComputeType: 'BUILD_GENERAL1_SMALL'
        Image: 'aws/codebuild/nodejs:6.3.1'
        Type: 'LINUX_CONTAINER'
      Name: !Sub '${AWS::StackName}-app'
      ServiceRole: !GetAtt 'CodeBuildRole.Arn'
      Source:
        Type: CODEPIPELINE
        BuildSpec: |
          version: 0.1
          phases:
            build:
              commands:
              - 'cd app/ && npm install'
              - 'cd app/ && npm test'
              - 'rm -rf app/node_modules/'
              - 'rm -rf app/test/'
              - 'cd app/ && npm install --production'
          artifacts:
            files:
            - 'app/**/*'
      TimeoutInMinutes: 10
```
* Enfin rajouter une étape (stage) au pipeline :
```
      - Name: Build
        Actions:
        - Name: BuildAndTestApp
          ActionTypeId:
            Category: Build
            Owner: AWS
            Provider: CodeBuild
            Version: 1
          Configuration:
            ProjectName: !Ref AppProject
          InputArtifacts:
          - Name: Source
          OutputArtifacts:
          - Name: App
          RunOrder: 1
```
* On peut maintenant sauvegarder les changements et les envoyer pour relancer le Pipeline 
```
git add deploy/pipeline.yml
git commit -m "lab 02"
git push deploy master
```
-> Félicitations vous savez maintenant builder votre code à partir d'un pipeline 

## Déployer son application dans un environnement sans serveur avec Lambda
Dans cette dernière partie, nous allons utilier un deuxième template pour créer une stack Serverless basée sur Lambda, APi Gateway, CloudWatch et SNS.
Pour cela nous utilisons le framework SAM (Serverless Application Model) : https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html 
* Créer un dossier infrastructure et un fichier serverless.yaml :
```
mkdir infrastructure
touch serverless.yaml
```
* OUvrir le fichier et copier le contenu suivant à l'intérieur :
```
---
AWSTemplateFormatVersion: '2010-09-09'
Transform: 'AWS::Serverless-2016-10-31' # this line activates the SAM transformations!a
Description: 'Serverless'
Parameters:
  # S3Bucket and S3Key where the zipped code is located. This will be created with CodeBuild
  S3Bucket:
    Type: String
  S3Key:
    Type: String
  AdminEmail:
    Description: 'The email address of the admin who receives alerts.'
    Type: String
Resources:
  # A SNS topic is used to send alerts via Email to the value of the AdminEmail parameter 
  Alerts:
    Type: 'AWS::SNS::Topic'
    Properties:
      Subscription:
      - Endpoint: !Ref AdminEmail
        Protocol: email
  ApiGateway:
    Type: 'AWS::Serverless::Api'
    Properties:
      StageName: Prod
      DefinitionBody:
        swagger: '2.0'
        basePath: '/'
        info:
          title: Serverless
        schemes:
        - https
        # We want to validate the body and request parameters
        x-amazon-apigateway-request-validators:
          basic:
            validateRequestBody: true
            validateRequestParameters: true
        paths:
          '/{n}':
            parameters: # we expect one parameter in the path of type number
            - name: 'n'
              in: path
              description: 'N'
              required: true
              type: number
            get:
              produces:
              - 'text/plain'
              responses:
                '200':
                  description: 'factorial calculated'
                  schema:
                    type: number
              x-amazon-apigateway-request-validator: basic # enable validation for this resource
              x-amazon-apigateway-integration: # this section connect the Lambda function with the API Gateway
                httpMethod: POST
                type: 'aws_proxy'
                uri: !Sub 'arn:aws:apigateway:${AWS::Region}:lambda:path/2015-03-31/functions/${GetFactorialLambda.Arn}/invocations'
                passthroughBehavior: when_no_match
  ApiGateway5XXErrorAlarm:
    Type: 'AWS::CloudWatch::Alarm'
    Properties:
      AlarmDescription: 'Api Gateway server-side errors captured'
      Namespace: 'AWS/ApiGateway'
      MetricName: 5XXError
      Dimensions:
      - Name: ApiName
        Value: !Ref ApiGateway
      - Name: Stage
        Value: Prod
      Statistic: Sum
      Period: 60
      EvaluationPeriods: 1
      Threshold: 1
      ComparisonOperator: GreaterThanOrEqualToThreshold
      AlarmActions:
      - !Ref Alerts
      TreatMissingData: notBreaching
  GetFactorialLambda:
    Type: 'AWS::Serverless::Function'
    Properties:
      Handler: 'app/handler.factorial'
      Runtime: 'nodejs6.10'
      CodeUri:
        Bucket: !Ref S3Bucket
        Key: !Ref S3Key
      Events:
        Http:
          Type: Api
          Properties:
            Path: /{n}
            Method: get
            RestApiId: !Ref ApiGateway
  # This alarm is triggered, if the Node.js function returns or throws an Error
  GetFactorialLambdaLambdaErrorsAlarm:
    Type: 'AWS::CloudWatch::Alarm'
    Properties:
      AlarmDescription: 'GET /{n} lambda errors'
      Namespace: 'AWS/Lambda'
      MetricName: Errors
      Dimensions:
      - Name: FunctionName
        Value: !Ref GetFactorialLambda
      Statistic: Sum
      Period: 60
      EvaluationPeriods: 1
      Threshold: 1
      ComparisonOperator: GreaterThanOrEqualToThreshold
      AlarmActions:
      - !Ref Alerts
      TreatMissingData: notBreaching
  # This alarm is triggered, if the there are too many function invocations
  GetFactorialLambdaLambdaThrottlesAlarm:
    Type: 'AWS::CloudWatch::Alarm'
    Properties:
      AlarmDescription: 'GET /{n} lambda throttles'
      Namespace: 'AWS/Lambda'
      MetricName: Throttles
      Dimensions:
      - Name: FunctionName
        Value: !Ref GetFactorialLambda
      Statistic: Sum
      Period: 60
      EvaluationPeriods: 1
      Threshold: 1
      ComparisonOperator: GreaterThanOrEqualToThreshold
      AlarmActions:
      - !Ref Alerts
      TreatMissingData: notBreaching
# A CloudFormation stack can return information that is needed by other stacks or scripts.
Outputs:
  DNSName:
    Description: 'The DNS name for the API gateway.'
    Value: !Sub '${ApiGateway}.execute-api.${AWS::Region}.amazonaws.com'
    Export:
      Name: !Sub '${AWS::StackName}-DNSName'
  # The URL is needed to run the acceptance test against the correct endpoint
  URL:
    Description: 'URL to the API gateway.'
    Value: !Sub 'https://${ApiGateway}.execute-api.${AWS::Region}.amazonaws.com/Prod'
    Export:
      Name: !Sub '${AWS::StackName}-URL'
```
* Ce template contient : 
* * Une fonction Amazon Lambda
* * Une API Gateway 
* * Une surveillance avec des alarmaes basées sur CloudWatch
* * Des notifications envoyés par SNS
* Dans le dossier infrastructure on ajoute un fichier serverless.json qui contient les paramètres, ces paramètres sont récupérés dynamiquement par la fonction GetArtifcatAtt (plus d'info ici : https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/continuous-delivery-codepipeline-parameter-override-functions.html ) :
```
{
  "Parameters": {
    "S3Bucket": {"Fn::GetArtifactAtt": ["App", "BucketName"]},
    "S3Key": {"Fn::GetArtifactAtt": ["App", "ObjectKey"]},
    "AdminEmail": "your@email.com"
  }
}
```

* Ajouter une étape de déploiement à notre pipeline (dans le fichier pipeline.yaml)
```
   - Name: Production
        Actions:
        - Name: CreateChangeSet
          ActionTypeId:
            Category: Deploy
            Owner: AWS
            Provider: CloudFormation
            Version: 1
          Configuration:
            ActionMode: CHANGE_SET_REPLACE
            Capabilities: CAPABILITY_IAM
            RoleArn: !GetAtt 'CloudFormationRole.Arn'
            ChangeSetName: !Sub '${AWS::StackName}-production'
            StackName: !Sub '${AWS::StackName}-production'
            TemplatePath: 'Source::infrastructure/serverless.yml'
            TemplateConfiguration: 'Source::infrastructure/serverless.json'
          InputArtifacts:
          - Name: Source
          - Name: App
          RunOrder: 1
        - Name: ApplyChangeSet
          ActionTypeId:
            Category: Deploy
            Owner: AWS
            Provider: CloudFormation
            Version: 1
          Configuration:
            ActionMode: CHANGE_SET_EXECUTE
            Capabilities: CAPABILITY_IAM
            ChangeSetName: !Sub '${AWS::StackName}-production'
            StackName: !Sub '${AWS::StackName}-production'
          RunOrder: 2
```
* On peut maintenant sauvegarder et lancer un pipeline :
```
git add deploy/pipeline.yml
git add infrastructure/serverless.yaml
git add infrastructure/serverless.json
git commit -m "lab 03"
git push deploy master
```
-> Félicitation votre pipeline est maintenant capable également de déployer votre code sur une architecture serverless

## Nettoyage
* Assurer vous de supprimer l'ensemble des éléments créer pour cet aexercice : 
* * Supprimer le dépôt CodeCommit : learn-codepipeline-$user.
* * Aller dans la stack CloudFormation learn-codepipeline-$useret et noter le nom du bucket S3 avec sont ID ArtifactsBucket
* * Supprimer la stack CloudFormation learn-codepipeline-$user 
* * Supprimer le bucket S3 dont vous avez noter le nom depuis la stack CloudFormation
