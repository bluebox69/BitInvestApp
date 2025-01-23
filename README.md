BitInvest- App

Hierbei handelt es sich um das Abschlussprojekt in iOS-Advanced des Lehrgangs Web- und AppEntwicklung des Technikums Wiens.

Author: Paul Kogler

Infos zur App:
Mit der "BitInvest"-App kann man ein virtuelles Portfolio erstellen und verwalten.
Beim erstmaligen Starten der App wird ein Portfolio mit einem Startkapital von 20.000 $ in der Datenbank erstellt.
Mit diesem Kapital können Bitcoins gekauft und verkauft werden. Der aktuelle Bitcoin-Kurs wird dabei in Echtzeit über eine API geladen.
Alle Kauf- und Verkaufsorders werden in einer Transaktionsliste angezeigt.
Unter dem Menüpunkt "Settings" können Benutzer zusätzliches Guthaben auf ihr Konto laden oder das Portfolio auf die Ausgangswerte zurücksetzen.

Die Ermittlung des aktuellen Bitcoin-Kurses erfolgt über die CoinPaprika-API:
https://api.coinpaprika.com/v1/tickers/btc-bitcoin
(Hinweis: In der kostenlosen Version wird der Bitcoin-Kurs alle 5 Minuten aktualisiert.)

Verwendete Funktionalitäten:
1. Core Data:
  •	 Die App nutzt Core Data, um die Daten des Portfolios sowie die Investments dauerhaft zu speichern und zu verwalten.

2. Localization:
  •	Alle Texte in der App wurden mithilfe von Localization-Strings für Deutsch und Englisch übersetzt, sodass die App in beiden Sprachen verfügbar ist.

3. Local Notifications & Dialogs:
  •	Die App verwendet Lokale Benachrichtigungen, um den Benutzer daran zu erinnern, sein Portfolio zu überprüfen.
    Testweise wird die Benachrichtigung wenige Sekunden nach dem Beenden der App ausgelöst.

4. Notification Center:
  •	Das Notification Center wurde implementiert, um wichtige Statusänderungen in der App zu kommunizieren.
    Beispielsweise wird eine Alert-Nachricht ausgelöst, wenn der Geldbetrag im Portfolio 0,0 $ beträgt, um den Nutzer darauf aufmerksam zu machen.
  •	Beim Klick auf den Refresh-Button wird eine Toast-Message ausgelöst, die den aktuellen Bitcoin-Kurs anzeigt.

5. Animationen:
  •	Animationen geben dem Nutzer visuelles Feedback:
    o	Der Refresh-Button rotiert einmal, wenn das Portfolio aktualisiert wird.
    o	Der Gesamtwert im HomeScreen erhält eine Scale-Animation, um zu verdeutlichen, dass das Portfolio aktualisiert wurde.
    o	Wenn der Geldbetrag oder die Anzahl der Coins 0,0 erreicht, beginnen diese Werte rot zu blinken.
    o	Im Buy- und Sell-Screen hat der Confirm-Button einen "Wiggle"-Effekt, falls ungültige Eingaben gemacht werden
     (z. B. negative oder leere Werte; oder Werte die das Portfolio nicht erlauben, wie mehr Coins zu kaufen als Geld verfügbar ist).
