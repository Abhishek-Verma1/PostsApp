# PostsApp

## Introduction
The goal is to develop a small posts app where a user can login with his UserID and fetch his posts.
    
## Technical Details
This project is build using mvvm-c, clean architecture and using combine swift. And the main backbone of the architecure is the use-cases.
 
 ### Main Components:
 * **Domain**: The main layer where all the domain level things kept like entites, use-cases and the repository protocols.
   > 1. Entities: Contains all the busniess related entities for response and request.
   > 2. Repositories: Its contain all the repositories protocols as a abstraction.
   > 3. UseCases: Same as repositories abstraction its also having the use-cases of the whole application.Right now its containts the PostsAppUseCaseProtocol.
 
 * **Data**: This module is responsible for having all the implementation related to the domain like usecases and the repositories.
   > 1. Constants: Contains all data related constants like api url and others.
   > 2. Extensions: Having the helpfull extensions for the aditional feature for current classes.
   > 4. Repositories: Its Contains the define implementation of repositories which is defined in the Domain module.
   > 5. UseCases: 
 
  * **Network**:.
