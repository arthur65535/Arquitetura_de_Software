    workspace {
        
        //!identifiers hierarchical
        
        model {
            user = person "Data Analyst" {
                description "Um analista de dados da empresa que utiliza o serviço de chat bot"
            }
            BISystem = softwareSystem "BI System" {
                description "Sistema de BI utilizado pelo analista de dados, como Tableau e PowerBI"
                tags "BI System"
            }
            softwareSystem = softwareSystem "BoltChat Analytics" {
                boltchat_analytics = group "BoltChat Analytics" {
                    frontend = container "Frontend" {
                        technology "Javascript e React"
                        tags "Frontend"
                    }
                    olap_db = container "Banco de Dados OLAP" {
                        description "Ingere e armazena datasets"
                        technology "ClickHouse"
                        tags "olap_db"
                    }
                    oltp_db = container "Banco de dados OLTP" {
                        description "Armazena dados de autenticação e metadados da ingestões de datasets"
                        technology "PostgreSQL"
                        tags "oltp_db"
                    }
                    data_catalog = container "Catálogo de Dados" {
                        description "Armazena metadados dos datasets ingeridos"
                        technology "ClickHouse"
                        tags "data_catalog"
                    }
                    restful_web_service = container "RESTful Web Service" {
                        tags "restful_web_service"
                        models = component Models {
                            description "Modelos que representam as entidades de negócio"
                            tags "component"
                        }
                        database_connector = component "Database Conector" {
                            this -> oltp_db
                            tags "component"
                        }
                        repositories = component "repositories" {
                            description "Realizam as consultas realizadas no banco de dados de aplicação OLTP"
                            this -> database_connector
                            this -> models
                            tags "component"
                        }
                        clickhouse_service = component "ClickHouse Service" {
                            description "Módulo de serviço para o SGBD OLAP ClickHouse"
                            technology "clickhouse-go Golang driver for ClickHouse"
                            this -> olap_db
                            tags "component"
                        }
                        datahub_service = component "DataHub Service" {
                            description "Módulo de serviço para o o Catálogo de Dados DataHub"
                            this -> data_catalog
                            tags "component"
                        }
                        controllers = component "REST Controllers" {
                            this -> repositories
                            this -> datahub_service
                            this -> clickhouse_service
                            tags "component"
                        }
                        routers = component "HTTP Routers" {
                            frontend -> this "Mensagens HTTPS com dados em JSON"
                            this -> controllers
                            tags "component"
                        }

                    }
                }
        
                user -> frontend
                BISystem -> olap_db "Coleta dados via conector específico"
            }
    
        }
        
        views {
            container softwareSystem "Containers_All" "Containers" {
                include *
                autolayout
            }
    
            component restful_web_service "restful_web_service_containers" "RESTful Web Service Containers" {
                include *
                autolayout
            }
    
            styles {
                element "Person" {
                    shape Person
                }
                element "Frontend" {
                    shape WebBrowser
                    background #8CD0F0
                }
                element "BI System" {
                    shape Box
                    background "#DD8BFE"
                }
                element "restful_web_service" {
                    shape hexagon
                    background #91F0AE
                }
                element "oltp_db" {
                    shape cylinder
                    icon data:image/png;base64,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
                }
                element "data_catalog" {
                    shape cylinder
                    icon data:image/png;base64,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
                }
                element "olap_db" {
                    shape cylinder
                    icon data:image/png;base64,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
                }
                element "component" {
                    shape roundedbox
                }
                element "Service 1" {
                    background #91F0AE
                }
                /*element "Service 2" {
                    background #EDF08C
                }
                element "Service 3" {
                    background #8CD0F0
                }
                element "Service 4" {
                    background #F08CA4
                }
                element "Service 5" {
                    background #FFAC33
                }
                element "Service 6" {
                    background #DD8BFE
                }
                element "Service 7" {
                    background #89ACFF
                }
                element "Service 8" {
                    background #FDA9F4
                }*/
              
            }
    
        }
    
    }

