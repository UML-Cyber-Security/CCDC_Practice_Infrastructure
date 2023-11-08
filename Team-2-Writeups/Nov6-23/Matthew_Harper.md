# Nov 6 2023 Writeup <!-- omit from toc -->
This is a writeup for the aforementioned date above it is organized into the following 
- [Progress](#progress)
- [Observations](#observations)
- [Improvements/Reflection](#improvementsreflection)

## Progress 
Unlike the previous week, since we had extra time for setting up misconfigurations, and implementing them (including backdoors) there was some continued and persistent access outside of the C2 server justin uses. Otherwise the scripts were not substantial and persistance is an issue. Once we lose access there is nothing. And Ideas are not much when they are not implemented. I feel people have a bit of a better idea of what to look for, and worry about in regards to securing and monitoring their system.
## Observations
1. It is hard for people that do not know what they are doing to contribute. This is simply due to a lack of guidance and the short turnaround time for this. I think for future implementations of this, longer time periods would be useful. We are again time constrained; so this is not much of an option, but in an ideal world we would have longer prep times. (Exams are difficult)
2. The planning did not help. Individual conversations helped more but people were still confused as to what they were doing but mainly how they were supposed to do stuff. 
3. People did seem to learn, but I think the red team should focus more on the basics in some areas and have the Leads (Justin, Manoj, Pranathi (If there)) take more a guidance role than one of active participation.  
## Improvements/Reflection
1. Better planning, seemed like we could have used the time a bit better. Participation during the planning phase is not as important as understanding.
2. Documentation 
   * What are we doing? Were they reviewed? 
3. Experience 
   * Again this is the killer, we don't know what we are doing and don't know enough to be effective.
4. Infrastructure: 
   * When no one can SSH in, it's not fun
   * When your target is removed from the infrastructure it make the waste of time more apparent. Especially when it's removal is communicated by the other team in a casual conversation
5. There needs to be more of a fun atmosphere. Our goal is not to destroy them, or make their life difficult but do little prodding things right? 
   * Delete a text editor they use (Fun small and easily fixable thing), should be an easy incident 
   * Leave fun little files, incident 
   * turn off non-critical services, but don't hide it to the point there is no chance of finding it. There would be no growth.

We need to make scripts to harden and configure the systems. Bash first then whatever else.

We need to spend more time on persistance and configurations. 