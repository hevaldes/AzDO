# Entrenamiento Azure DevOps

## Generales

1. El objetivo de la prueba de concepto es crear un Azure Kubernetes Service y un Azure Container Registry con Terraform mediante un pipeline de CI.
2. Una vez creada la infraestructura, se necesitan generar un par de Service Connection en Azure DevOps para conectar con el AKS, el ACR y el portal de Microsoft Azure
3. Finalmente, se necesita la creación de un Pipeline de Releas para desplegar la aplicación en el AKS
4. Los pre requsitos son: Suscripción Microsoft Azure, Cuenta Azure DevOps con un proyecto creado (Git)

## Estructura del Repositorio

Los archivos en el repositorio son los necesarios para iniciar con la prueba de concepto

### Azure Kubernetes Service

| Archivo  | Descripción |
| ----------------- | ----------------- |
| [K8s manifest/Kubernetes.yml](https://github.com/hevaldes/AzDO/blob/main/K8s%20manifest/Kubernetes.yml)  | Contiene la descripción del despliegue de la imágen contenerizada. |


### Terraform

| Archivo  | Descripción |
| ----------------- | ----------------- |
| [Terraform-manifests/acr.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/acr.tf)  | Creación de Azure Container Registry. |
| [Terraform-manifests/k8s.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/k8s.tf)  | Creación de Azure Kubernetes Service |
| [Terraform-manifests/main.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/main.tf)  | Información general de Terraform |
| [Terraform-manifests/outputs.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/outputs.tf)  | Salidas generadas Terraform |
| [Terraform-manifests/variables.tf](https://github.com/hevaldes/AzDO/blob/main/Terraform-manifests/variables.tf)  | Archivo de Variables |

### App .NET Core Demo

| Folder  | Descripción |
| ----------------- | ----------------- |
| [DemoAppNET](https://github.com/hevaldes/AzDO/tree/main/DemoAppNET)  | Aplicación .NET Core con DockerFile para contenerizar |


### Pipelies

| Archivo  | Descripción |
| ----------------- | ----------------- |
| [SantanderApp-CI.yml](https://github.com/hevaldes/AzDO/blob/main/SantanderApp-CI.yml)  | Pipeline para creación de infraestructura Terraform |
| [SantanderInfra-CI.yml](https://github.com/hevaldes/AzDO/blob/main/SantanderApp-CI.yml)  | Pipeline para contenerización y despliegue de imágen en ACR |

## Orden de implementación de la prueba de concepto

## Configuraciones en Azure DevOps

1. Tener acceso a una suscripción Microsoft Azure para la creación de los recursos
2. Tener una cuenta Azure DevOps con un proyecto creado. Agile/Git
3. Contar con el todo el repositorio restaurado en Azure Repositories dentro de Azure DevOps o bien en GitHub conectado a Azure Pipelines

[![Image](https://.png "AWS EKS Kubernetes - Masterclass")]


4. 
