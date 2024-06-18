**UMass Lowell - CCDC Team Repo.**  
 
-----------------------------------------------------------------------------------------------------------------------  

Repo. Structure:  
  
## 1. Documentation  
   - ### OperatingSystems                              
     - #### Name of OS                                    
       - **install**                           
         - *README.md* - Documentation detailing how to install OS    
       - **services**  
         - *README.md* - Documentation of Author/Contributor (Who contributed this documentation?)  
           - ##### Name of service
             - *README.md* - Documentation of service - Refer to service documentation styleguide[ here.](./Procedures/styleguides/serviceDocumentationStyleGuide.md)  
             - Any necessary scripts, linked to through *Scripts/README.md*
   - ### Networking
     - For now, just an update document for each meeting  
## 2. Procedures  
   - ### resources
     - [*ip-list.md*](Procedures/resources/ip-list.md) - Current mapping of lab network  
     - [*methodology.md*](Procedures/resources/methodology.md) 
     - [*roster.md*](Procedures/resources/roster.md)  
     - [*SOPs.md*](Procedures/resources/SOPs.md) - Standard Operating Procedures : [Definition](https://www.merriam-webster.com/dictionary/standard%20operating%20procedure)  
     - [*todo.md*](Procedures/resources/todo.md)  
     - [*webinar.md*](Procedures/resources/webinar.md)  
   - ### schedules  
     - **Month**  
       - *day_month.md* - Documentation of upcoming practice schedule, deliverables, structure    
   - ### styleguides  
     - (documentType)Styleguide.md - Standard to follow when writing and contributing documents  
## 3. Scripts  
   - README.md with relative links to all submitted scripts within repo  
   
# Printing Instructions

In order to print any/all documentation in this repo,
we need to convert all markdown into pdf. Todo this,
simply run `make -i` (some files will fail, this is normal for now)

If you value your time, run `make -i -jN` where N is the
number of threads on your machine.
All generated pdfs will be located in `printable`

----------------------------------------------------------------------------------------------------------------------- 
