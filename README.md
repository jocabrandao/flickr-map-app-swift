# flickr-map-app-swift
 Aplicação de referência, cujo objetivo é exemplificar o uso de Swift para implementação de aplicação para iOS.
 
## Resumo

Baixando este exemplo você vai encontrar o uso de:
 - Integração com a API REST do Flickr: flickr.photos.search e flickr.photos.getSizes
 - Busca através de coordenadas de Latitude e Longitude (Geolozalização)
 - Paginação dos resultados integrado com a API REST
 - Permite escolhar no mapa o local que deseja buscar fotos
 - Rolagem infinita do scrooll
 - Uso de Cache (dados de resposta do cache para evitar bater na rede toda vez)
 - Testes Unitários
 - Testes de Interface

Para construir foi utilizado:

 - Storyboard
 - Protocol
 - UIView
 - UILabel
 - UIImage
 - UIImageView
 - UIColor
 - UICollectionViewFlowLayout
 - UICollectionView
 - MKMapView
 - MKAnnotation
 - CLLocationCoordinate2D
 - UIGestureRecognizerDelegate
 - CLLocationManager

Além disso, tem também:
 - Alamofire (Componente de parse HTTP)
 - Autolayout
 - Stack View

## Screenshots
Veja na pasta: Screenshots.

## Construído utilizando

* [Xcode 9.4.1](https://developer.apple.com/xcode) - IDE de desenvolvimento.
* [Cocoa Pods](https://cocoapods.org) - Gerenciador de dependências.
* [Alamofire](https://github.com/Alamofire/Alamofire) - Componente para parse de requisições HTTP.

## Autor

* **João Carlos Brandão Morgado** - *Trabalho Inicial* - [joaobrandao](https://github.com/jocabrandao)

## Licença

MIT 
