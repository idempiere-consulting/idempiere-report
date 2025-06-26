# idempiere-report

# Design report Jasper

Best practices e operazioni standard per la progettazione di report con motore jasper

# Integrazione con iDempiere

Sfruttando l'integrazione con iDempiere è possibile produrre report multilingua, personalizzati per organizzazione utilizzando le integrazioni di iDempiere.

# Numerazione report
Numerare in maniera univoca i report. I report sono divisi in tre gruppi gerarchici, che rispettano la struttura del menu. La divisione è prettamente funzionale in modo da avere i report divisi per utilizzo.
Ad esempio:
- ...
- 4 - Quote to invoice
  - 4.1 - Invoice
    - 4.1.1 - Invoice SO
- ...
- 8 - Open items account
  - 8.1 - Financial reports
    - 8.1.2 - VAT Journal summary report
  - 8.2 - Open items
- ...

La numerazione servirà anche per la gestione di qualche traduzione, parametri, etc...

# Multilingua

Un'implementazione di Resource Bundle supportata da AD_Message e AD_Element viene passata al Jasper Report utilizzando il parametro standard **REPORT_RESOURCE_BUNDLE**. Se insieme al file .jrxml viene distribuito un file di proprietà del bundle di risorse, questo avrà la precedenza sulle risorse AD_Message e AD_Element.

Nel report, utilizzare la funzione *str* per ottenere il testo tradotto da AD_Message o AD_Element (o dal file delle proprietà, se è stato distribuito). Ad esempio, *str("IsDefault")*

Si noti che questo non funzionerà quando si esegue l'anteprima con Jasper Report Studio. Per ottenere un risultato ragionevole in Jasper Report Studio, è possibile utilizzare un'espressione condizionale, ad esempio: *str("IsDefault") != null ? str("IsDefault") : "str(IsDefault)"*.

**Sfruttare le tabelle AD_Message e AD_Element è consigliato**

[https://wiki.idempiere.org/en/NF9_AD_Resource_Bundle_For_Jasper_Report](https://wiki.idempiere.org/en/NF9_AD_Resource_Bundle_For_Jasper_Report)

## Traduzioni specifiche
Nel caso servano testi aggiuntivi non esistenti
1. Creare un nuovo messaggio nella tabella AD_Message, a livello System o Organizzazione. Aprire la finestra **Messaggio [MESS00]** e aggiungere un nuovo record
2. Chiamare la variabile **LIT_REP_<nr report>_<messaggio>** sostituendo <nr report> e <messaggio> con il numero del report che ne farà uso e <messaggio> con un indicatore del contenuto del messaggio. Ad esempio **LIT_REP_812_Credit**.
3. Usare **Informazioni** come tipo messaggio
4. Usare l'entità preferita, oppure un'entità specifica per lo scopo
5. Il testo del messaggio va specificato in inglese, per standard.
6. Il tab **Traduzione** permette di compilare i testi tradotti e spuntare la casella nelle lingue già elaborate

# Parametri report
Vengono sempre passate le variabili di contesto a jasper con ad esempio **AD_CLIENT_ID**, **AD_Org_ID**, **AD_Language**, etc...
La lingua **AD_Language** viene passata come parametro standard **REPORT_LOCALE** per permettere a jasper di funzionare correttamente.

I report sono parametrizzabili tramite la configurazione di sistema di iDempiere.

Creare una variabile di sistema (a livello system, client oppure organizzazione) chiamandola **LIT_REP_<nr report>_<variabile>** sostituendo <nr report> e <variabile> con il numero del report che ne farà uso e <variabile> con un indicatore della funzione comandata dal parametro.

Ad esempio **LIT_REP_411_PrintPriceList** indica che il parametro è usato dal report 411 e comanda la stampa del prezzo di listino.

Se una variabile è comune a tutti i report omettere il numero di report nel nome, ad esempio **LIT_REP_PrintHeader** è usata in tutti i report e pilota la stampa dell'intestazione.

I parametri sono recuperabili via SQL direttamente dal report tramite la funzione *get_sysconfig(variable, default, ad_client_id, ad_org_id)*. è quindi possibile aggiungere la funzione come campo in ogni istruzione SELECT, secondo necessità. Ad esempio **get_sysconfig('LIT_REP_411_PrintPriceList', 'N', $P{AD_CLIENT_ID}, $P{AD_Org_ID}) as ad_sysconfig_printpricelist)** torna il campo $F{ad_sysconfig_printpricelist} valorizzato con il valore salvato oppure 'N' se la variabile non esiste.