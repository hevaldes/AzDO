# Entrenamiento Azure DevOps
___

## Generales

1. El objetivo de la prueba de concepto es crear un clúster de Azure Kubernetes Service y un Azure Container Registry. Ambos con Terraform mediante un pipeline de CI.
2. Una vez creada la infraestructura, se necesitan generar un par de Service Connection en Azure DevOps para conectar con el AKS, el ACR y el portal de Microsoft Azure.
3. Se necesita la creación de un Pipeline de CI para la contenerización de la aplicación .NET de ejemplo y la generación de los artefactos.
4. Finalmente, un pipeline de Release para desplegar la aplicación en el AKS.
5. Los pre requsitos son: Suscripción Microsoft Azure, Cuenta Azure DevOps con un proyecto creado (Git).
6. El repositorio aqui en GitHub ya tiene la llave .pub de seguridad agregada y que se necesita para la creación del clúster de AKS. Sin embargo a continuación se describe como generarla. 

```
ssh-keygen -m PEM -t rsa -b 4096 -C "sntdruser@demopoc" -f aks-terraform-devops-sshkey
```
![Image](https://github.com/hevaldes/AzDO/blob/main/assets/ssh.png "SSH Key")

7. Se necesitará agregar del [Marketplace](https://marketplace.visualstudio.com/azuredevops?utm_source=vstsproduct&utm_medium=L1BrowseMarketplace&targetId=8bc5a556-3b10-4268-8754-c1fc189ef7b4) la extensión de [Terraform - Microsoft DevLabss](https://marketplace.visualstudio.com/azuredevops?utm_source=vstsproduct&utm_medium=L1BrowseMarketplace&targetId=8bc5a556-3b10-4268-8754-c1fc189ef7b4)

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/TerraformExtension.PNG "Terraform Microsoft Extension")
___

## Estructura del Repositorio

Los archivos en el repositorio son los necesarios para iniciar con la prueba de concepto

#### Azure Kubernetes Service

| Archivo  | Descripción |
| ----------------- | ----------------- |
| [K8s manifest/Kubernetes.yml](https://github.com/hevaldes/AzDO/blob/main/K8s%20manifest/Kubernetes.yml)  | Contiene la descripción del despliegue de la imágen contenerizada. |


#### Terraform

| Archivo  | Descripción |
| ----------------- | ----------------- |
| [Terraform-manifests/acr.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/acr.tf)  | Creación de Azure Container Registry. |
| [Terraform-manifests/k8s.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/k8s.tf)  | Creación de Azure Kubernetes Service |
| [Terraform-manifests/main.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/main.tf)  | Información general de Terraform |
| [Terraform-manifests/outputs.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/outputs.tf)  | Salidas generadas Terraform |
| [Terraform-manifests/variables.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/variables.tf)  | Archivo de Variables |

#### App .NET Core Demo

| Folder  | Descripción |
| ----------------- | ----------------- |
| [DemoAppNET](https://github.com/hevaldes/AzDO/tree/main/DemoAppNET)  | Aplicación .NET Core con DockerFile para contenerizar |


#### Pipelines

| Archivo  | Descripción |
| ----------------- | ----------------- |
| [PipelineInfra-CI.yml](https://github.com/hevaldes/AzDO/blob/main/PipelineApp-CI.yml)  | Pipeline para contenerización y despliegue de imágen en ACR |

___

## Orden de implementación de la prueba de concepto

#### 1. Configuraciones en Azure DevOps

1. Tener acceso a una suscripción Microsoft Azure para la creación de los recursos
2. Tener una cuenta Azure DevOps con un proyecto creado. Agile/Git
3. Contar con el todo el repositorio restaurado en Azure Repositories dentro de Azure DevOps o bien en GitHub conectado a Azure Pipelines

#### 2. Creación de Service Connection para Microsoft Azure

Esta conexión será utilizada por el pipeline llamado PipelineInfra-CI.yml para la creación del archivo de estado de Terraform en una cuenta de almacenamiento. 

1. En Azure DevOps ir a Project Settings

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/ProjectSettings.PNG "Project Settings")

2. En la sección de Pipelines, seleccionar Service Connections

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/ServiceConnections.PNG "Service Connections")

3. Clic en New Service Connection

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/NewServiceConnection.PNG "New Service Connection")

4. Seleccionar Azure Resource Manager y seguir con los pasos para conectar Azure DevOps con el portal de Microsoft Azure. Al nombrar esta conexión, podrá ser utilizada en la siguiente sección al configurar el pipeline de Infraestructura. 

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/ARM.PNG "Azure Resource Manager")


#### 3. Creación de Pipeline Terraform

El pipeline existente en el repositorio servirá para generar el pipelines requerido. 

1. Crear el pipeline basado en el ya existente en el repositorio. 
2. Clic en Pipelines --> New Pipeline --> Seleccionar "Azure Repos Git YAML"

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/GitRepo.PNG "Azure Repo - Git")

3. Seleccionar el Repositorio. Puede ser Azure Repos o bien GitHub

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/SelectRepo.PNG "Select Azure Repo")

4. Seleccionar "Existing Azure Pipeline YAML File"

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/ExistingYAML.PNG "Select Existing YAML")

5. Seleccionar el Pipeline y clic en Continue

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/ExistingPipeline.PNG "Existing Pipeline YAML")

6. Adecuar el pipeline en donde dice: "[SERVICE_CONNECTION_AZURE]" en la sección de variables.

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/variables.PNG "Variables")

7. Ejecutar y validar resultados

#### 4. Creación de Service Connection para AKS y ACR

Una vez ejecutado el pipeline de Infraestructura, seguir los pasos descritos en la sección "2. Creación de Service Connection para Microsoft Azure" para crear las conexiones al clúster de AKS y el ACR. Estas 2 conexiones serám utilizadas los siguientes pipelines. (CI/CD)


#### 5. Creación Pileline de CI

En este caso tenemos una aplicación .NET para lo cual se creará un pieline de CI de tipo Classic. Puede ser también de tipo YAML. Este pipeline contendrá: 

* Tarea de Copy Files para obtener el manifiesto de Kubernetes y dejarlo como artefacto en la fase de Release
* Hacer el Build and Push del código demo al ACR

Creacíón del Pipeline: 

1. Crear nuevo Pipeline de tipo Classic. 
2. Template a seleccionar: ASP.NET Core
3. Una vez creado el Pipeline, dejar solo las siguientes tareas.

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/PipelineCI.PNG "Pipeline CI")

4. Donde la tarea "BuildandPush" tiene las siguientes configuraciones. En donde dice Container Repository establecer namespace/demoappnet donde namespace puede ser el nombre de la compañia, proyecto, etc. Ej: miempresa/demoappnet. Es importante recordar este dato ya que será utilizado en la fase de release. 

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/BuildandPush.PNG "Build and Push")

5. La tarea "Copy Files" copiará del repositorio el manifiesto para AKS

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/Manifiesto.PNG "Manifiesto K8s")

6. Ejecutar y validar resultados

#### 5. Creación Pileline de CD

1. En la sección de Relase, generar un nuevo Pipeilne de Release. 
2. Seleccionar "Empty Job"

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/EmptyJob.png "Empty Job")

3. Opcionalmente dar un nombre al Stage
4. Agregar un nuevo artefacto y seleccionar el pipelie que conteneriza la aplicación demo
5. En el Stage a implementar, agregar 2 tareas de tipo "Deploy to Kubernetes" y nombrarlas como menciona la imágen

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/K8sTasks.PNG "K8s Tasks")

6. Configurar la tarea "Create Secret to allow image pull from ACR" como sigue

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/K8sCreateSecret.PNG "Create Secret AKS")

7. Configurar la tarea "Deploy to AKS" como sigue

![Image](https://github.com/hevaldes/AzDO/blob/main/assets/DeployTasks.png "Deploy AKS")

En esta tarea, asignar correctamente la propiedad Container, donde respecto a la imágen: [ACR_URL]/[namespace]/demoappnet:$(Build.BuildId)

```
ACR_URL: Url del Azure Container Registry. Ej: miregistry.azurecr.io
namespace: Se refiere al asignado en la sección "5. Creación Pileline de CI" punto "#4"
```

8. Ejecutar

___





