//
//  Uppgift.swift
//  HabitMaker
//
//  Created by Karl Nyhlin on 2024-05-02.
//

import Foundation
/*
Du ska skapa en app där användaren kan lägga till nya vanor (habits) och markera om de har utfört dem varje dag. Appen ska ha följande funktioner:

G:
En lista över alla vanor som användaren har lagt till.
Möjlighet att lägga till nya vanor genom att ange namnet på vanan.
Möjlighet att markera om en vana har utförts varje dag genom att klicka på en knapp bredvid vanans namn.
Lagring av hur långt en "streak" är för varje vana, dvs. hur många dagar i rad vanan har utförts.
VG:
En sammanställning av användarens utförda vanor för varje dag, vecka och månad.
Möjlighet att ställa in påminnelser för varje vana, så att användaren får en påminnelse att utföra vanan vid en specifik tidpunkt varje dag.

Du väljer själv om din app skall vara skapad i swiftui eller med storyboard. Du väljer också vilken databas du skall använda, Firebase Firestore, Swift Data eller  Core Data .
 
 Min beskrivning/pseudokod:
 
 Startsida:
 Visar en scrollview med habits som man har lagt till.
 Varje cell visar namnet på vanan och streak (OBS alltså inte datumet då det skapades) samt en knapp för "done". Man kan också klicka på texten för att komma till en sida som visar komplett info om den vanan (Infosida).
 
 SÅ HÄR KAN "DONE" FUNKA:
 När man klickar "done" sparas en doneTimeStamp. Om man avmarkerar "done" sätts doneTimeStamp tillbaka till 0(?).
 
 På startsidan finns också en knapp för "add habit" och en knapp för "my statistics".
 
 Infosida:
 Här ser man komplett info om vanan. Man kan också editera och spara ändringar, och ställa in påminnelser.
 
 Add habit:
 På denna sida får man fylla i name och description och spara eller gå tillbaka. När man trycker save kommer man också tillbaka till startsidan och den nya vanan läggs till i listan.
 
 My statistics:
 På denna sida ser man (helst) en graf(?) över de senaste månaderna med olika linjer. Längst ner står vad varje linje representerar för vana.
*/
