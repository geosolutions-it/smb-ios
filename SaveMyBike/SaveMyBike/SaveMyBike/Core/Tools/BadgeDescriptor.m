
#import "BadgeDescriptor.h"

#import "STSI18n.h"

@implementation BadgeDescriptor;

- (id)init
{
	self = [super init];
	if(!self)
		return nil;

	_titles = [NSMutableDictionary new];
	_descriptions = [NSMutableDictionary new];
	_greetings = [NSMutableDictionary new];

	[_titles setObject:__trCtx(@"Nuovo Utente!! ",@"BadgeDescriptor") forKey:@"new_user"];
	[_descriptions setObject:__trCtx(@"Appena ti iscrivi ed installi l’APP guadagni questo badge",@"BadgeDescriptor") forKey:@"new_user"];
	[_greetings setObject:__trCtx(@"Benvenuto e pronto a partire con una mobilità più sostenibile ed ecologica!! Condividi i tuoi risultati con tuoi amici e sfidali in competizioni personali!",@"BadgeDescriptor") forKey:@"new_user"];

	[_titles setObject:__trCtx(@"Rilevatore in erba!!",@"BadgeDescriptor") forKey:@"data_collector_level0"];
	[_descriptions setObject:__trCtx(@"Quando inizi ad inserire i dati di rilevamento dei tuoi modi di trasporto, ottieni questo badge",@"BadgeDescriptor") forKey:@"data_collector_level0"];
	[_greetings setObject:__trCtx(@"Ottimo!! Hai iniziato a registrare i tuoi percorsi, così potrai collezionare nuovi badges e crescere il tuo punteggio!! Continua così! Le statistiche che ti forniamo ti mostreranno come puoi risparmiare tempo, soldi e salute, muovendoti in modo sostenibile!!",@"BadgeDescriptor") forKey:@"data_collector_level0"];

	[_titles setObject:__trCtx(@"Rilevatore – 1 stella!!",@"BadgeDescriptor") forKey:@"data_collector_level1"];
	[_descriptions setObject:__trCtx(@"Quando hai registrato attività in una settimana per ogni giorno, otterrai questo badge.",@"BadgeDescriptor") forKey:@"data_collector_level1"];
	[_greetings setObject:__trCtx(@"Ottimo!! Hai registrato i tuoi percorsi in una settimana intera, così potrai collezionare nuovi badges e crescere il tuo punteggio!! Continua così! Le statistiche che ti forniamo ti mostreranno come puoi risparmiare tempo, soldi e salute, muovendoti in modo sostenibile!!",@"BadgeDescriptor") forKey:@"data_collector_level1"];

	[_titles setObject:__trCtx(@"Rilevatore – 2 stelle!!",@"BadgeDescriptor") forKey:@"data_collector_level2"];
	[_descriptions setObject:__trCtx(@"Quando hai registrato attività in due settimane per ogni giorno, otterrai questo badge.",@"BadgeDescriptor") forKey:@"data_collector_level2"];
	[_greetings setObject:__trCtx(@"Ottimo!! Hai registrato i tuoi percorsi in due intere settimane, così potrai collezionare nuovi badges e crescere il tuo punteggio!! Continua così! Le statistiche che ti forniamo ti mostreranno come puoi risparmiare tempo, soldi e salute, muovendoti in modo sostenibile!!",@"BadgeDescriptor") forKey:@"data_collector_level2"];

	[_titles setObject:__trCtx(@"Rilevatore – 3 stelle!!",@"BadgeDescriptor") forKey:@"data_collector_level3"];
	[_descriptions setObject:__trCtx(@"Quando hai registrato attività in un mese per ogni giorno, otterrai questo badge.",@"BadgeDescriptor") forKey:@"data_collector_level3"];
	[_greetings setObject:__trCtx(@"Ottimo!! Hai registrato i tuoi percorsi in un intero mese, così potrai collezionare nuovi badges e crescere il tuo punteggio!! Continua così! Le statistiche che ti forniamo ti mostreranno come puoi risparmiare tempo, soldi e salute, muovendoti in modo sostenibile!!",@"BadgeDescriptor") forKey:@"data_collector_level3"];

	[_titles setObject:__trCtx(@"Biker - 1 stella!!",@"BadgeDescriptor") forKey:@"biker_level1"];
	[_descriptions setObject:__trCtx(@"Inizia ad utilizzare la tua bici in città!! Usa la bici tre volte in una settimana ed otterrai questo badge.",@"BadgeDescriptor") forKey:@"biker_level1"];
	[_greetings setObject:__trCtx(@"Ottimo! Con i tuoi spostamenti cittadini in bici sei entrato nel gruppo dei bikers!!",@"BadgeDescriptor") forKey:@"biker_level1"];

	[_titles setObject:__trCtx(@"Biker - 2 stelle!!",@"BadgeDescriptor") forKey:@"biker_level2"];
	[_descriptions setObject:__trCtx(@"Riutilizza la bici altre tre volte in città nella prossima settimana ed otterrai questo badge.",@"BadgeDescriptor") forKey:@"biker_level2"];
	[_greetings setObject:__trCtx(@"Bene! Sei riuscito ad utilizzare la bici in città sei volte in due settimane!! Aria fresca e movimento!!",@"BadgeDescriptor") forKey:@"biker_level2"];

	[_titles setObject:__trCtx(@"Biker - 3 stelle!!",@"BadgeDescriptor") forKey:@"biker_level3"];
	[_descriptions setObject:__trCtx(@"Riutilizza la bici in città altre sei volte nelle prossime due settimane ed otterrai questo badge!!",@"BadgeDescriptor") forKey:@"biker_level3"];
	[_greetings setObject:__trCtx(@"Bene! Sei riuscito ad utilizzare la bici dodici volte in quattro settimane dentro la tua città!! Aria fresca e movimento!!",@"BadgeDescriptor") forKey:@"biker_level3"];

	[_titles setObject:__trCtx(@"Mobilità Collettiva – 1 stella!!",@"BadgeDescriptor") forKey:@"public_mobility_level1"];
	[_descriptions setObject:__trCtx(@"Blocca la tua auto ed utilizza il trasporto pubblico urbano(tramvia, bus, metro)! Al primo utilizzo del trasporto pubblico otterrai questo badge.",@"BadgeDescriptor") forKey:@"public_mobility_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai utilizzato per la prima volta il trasporto pubblico! Sei più sostenibile risparmiando soldi e tempo!  ",@"BadgeDescriptor") forKey:@"public_mobility_level1"];

	[_titles setObject:__trCtx(@"Mobilità Collettiva – 2 stelle!!",@"BadgeDescriptor") forKey:@"public_mobility_level2"];
	[_descriptions setObject:__trCtx(@"Blocca la tua auto ed utilizza il trasporto pubblico urbano(tramvia, bus, metro)! Al quinto utilizzo del trasporto pubblico otterrai questo badge.",@"BadgeDescriptor") forKey:@"public_mobility_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai utilizzato per sei volte il trasporto pubblico! Sei più sostenibile risparmiando soldi e tempo!",@"BadgeDescriptor") forKey:@"public_mobility_level2"];

	[_titles setObject:__trCtx(@"Mobilità Collettiva – 3 stelle!!",@"BadgeDescriptor") forKey:@"public_mobility_level3"];
	[_descriptions setObject:__trCtx(@"Blocca la tua auto ed utilizza il trasporto pubblico urbano(tramvia, bus, metro)! Al decimo utilizzo del trasporto pubblico otterrai questo badge.",@"BadgeDescriptor") forKey:@"public_mobility_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai utilizzato per dieci volte il trasporto pubblico! Sei più sostenibile risparmiando soldi e tempo!",@"BadgeDescriptor") forKey:@"public_mobility_level3"];

	[_titles setObject:__trCtx(@"Bike Surfer – 1 stella!!",@"BadgeDescriptor") forKey:@"bike_surfer_level1"];
	[_descriptions setObject:__trCtx(@"Utilizza la bici per almeno 10 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"bike_surfer_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 10 km in bici all’interno della tua città. ",@"BadgeDescriptor") forKey:@"bike_surfer_level1"];

	[_titles setObject:__trCtx(@"Bike Surfer – 2 stelle!!",@"BadgeDescriptor") forKey:@"bike_surfer_level2"];
	[_descriptions setObject:__trCtx(@"Utilizza la bici per almeno 50 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"bike_surfer_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 50 km in bici all’interno della tua città. ",@"BadgeDescriptor") forKey:@"bike_surfer_level2"];

	[_titles setObject:__trCtx(@"Bike Surfer – 3 stelle!!",@"BadgeDescriptor") forKey:@"bike_surfer_level3"];
	[_descriptions setObject:__trCtx(@"Utilizza la bici per almeno 100 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"bike_surfer_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 100 km in bici all’interno della tua città. ",@"BadgeDescriptor") forKey:@"bike_surfer_level3"];

	[_titles setObject:__trCtx(@"TPL Surfer – 1 stella!!",@"BadgeDescriptor") forKey:@"tpl_surfer_level1"];
	[_descriptions setObject:__trCtx(@"Utilizza l’autobus per almeno 25 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"tpl_surfer_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 25 km in autobus all’interno della tua città. ",@"BadgeDescriptor") forKey:@"tpl_surfer_level1"];

	[_titles setObject:__trCtx(@"TPL Surfer – 2 stelle!!",@"BadgeDescriptor") forKey:@"tpl_surfer_level2"];
	[_descriptions setObject:__trCtx(@"Utilizza l’autobus per almeno 100 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"tpl_surfer_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 100 km in autobus all’interno della tua città. ",@"BadgeDescriptor") forKey:@"tpl_surfer_level2"];

	[_titles setObject:__trCtx(@"TPL Surfer – 3 stelle!!",@"BadgeDescriptor") forKey:@"tpl_surfer_level3"];
	[_descriptions setObject:__trCtx(@"Utilizza l’autobus per almeno 200 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"tpl_surfer_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 200 km in autobus all’interno della tua città. ",@"BadgeDescriptor") forKey:@"tpl_surfer_level3"];

	[_titles setObject:__trCtx(@"Multi Surfer – 1 stella!!",@"BadgeDescriptor") forKey:@"multi_surfer_level1"];
	[_descriptions setObject:__trCtx(@"Utilizza mezzi sostenibili per almeno 100 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"multi_surfer_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 100 km con più mezzi sostenibili!! Stai dando un grande aiuto alla collettività!!",@"BadgeDescriptor") forKey:@"multi_surfer_level1"];

	[_titles setObject:__trCtx(@"Multi Surfer – 2 stelle!!",@"BadgeDescriptor") forKey:@"multi_surfer_level2"];
	[_descriptions setObject:__trCtx(@"Utilizza mezzi sostenibili per almeno 250 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"multi_surfer_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 250 km con più mezzi sostenibili!! Stai dando un grande aiuto alla collettività!!",@"BadgeDescriptor") forKey:@"multi_surfer_level2"];

	[_titles setObject:__trCtx(@"Multi Surfer – 3 stelle!!",@"BadgeDescriptor") forKey:@"multi_surfer_level3"];
	[_descriptions setObject:__trCtx(@"Utilizza mezzi sostenibili per almeno 500 km in ambito urbano ed otterrai questo badges! Hai dato un grande apporto alla mobilità sostenibile nella tua città!",@"BadgeDescriptor") forKey:@"multi_surfer_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai percorso 500 km con più mezzi sostenibili!! Stai dando un grande aiuto alla collettività!!",@"BadgeDescriptor") forKey:@"multi_surfer_level3"];

	[_titles setObject:__trCtx(@"Ecologista – 1 stella!!",@"BadgeDescriptor") forKey:@"ecologist_level1"];
	[_descriptions setObject:__trCtx(@"Evita le emissioni per 25 kg di CO2 in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"ecologist_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai evitato di emettere 25 kg di CO2 all’interno della tua città.Hai dato un grande apporto al mantenimento della qualità dell’aria nella tua città!",@"BadgeDescriptor") forKey:@"ecologist_level1"];

	[_titles setObject:__trCtx(@"Ecologista – 2 stelle!!",@"BadgeDescriptor") forKey:@"ecologist_level2"];
	[_descriptions setObject:__trCtx(@"Evita le emissioni per 50 kg di CO2 in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"ecologist_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai evitato di emettere 50 kg di CO2 all’interno della tua città.Hai dato un grande apporto al mantenimento della qualità dell’aria nella tua città!",@"BadgeDescriptor") forKey:@"ecologist_level2"];

	[_titles setObject:__trCtx(@"Ecologista – 3 stelle!!",@"BadgeDescriptor") forKey:@"ecologist_level3"];
	[_descriptions setObject:__trCtx(@"Evita le emissioni per 100 kg di CO2 in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"ecologist_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai evitato di emettere 100 kg di CO2 all’interno della tua città.Hai dato un grande apporto al mantenimento della qualità dell’aria nella tua città!",@"BadgeDescriptor") forKey:@"ecologist_level3"];

	[_titles setObject:__trCtx(@"Salutista – 1 stella!!",@"BadgeDescriptor") forKey:@"healthy_level1"];
	[_descriptions setObject:__trCtx(@"Consuma un totale di 750 calorie grazie ai tuoi spostamenti “attivi” in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"healthy_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai consumato 750 calorie grazie ai tuoi spostamenti all’interno della tua città.Non inquinando ti stai tenendo in forma!!",@"BadgeDescriptor") forKey:@"healthy_level1"];

	[_titles setObject:__trCtx(@"Salutista – 2 stelle!!",@"BadgeDescriptor") forKey:@"healthy_level2"];
	[_descriptions setObject:__trCtx(@"Consuma un totale di 2.250 calorie grazie ai tuoi spostamenti “attivi” in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"healthy_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai consumato 2.250 calorie grazie ai tuoi spostamenti all’interno della tua città.Non inquinando ti stai tenendo in forma!!",@"BadgeDescriptor") forKey:@"healthy_level2"];

	[_titles setObject:__trCtx(@"Salutista – 3 stelle!!",@"BadgeDescriptor") forKey:@"healthy_level3"];
	[_descriptions setObject:__trCtx(@"Consuma un totale di 4.500 calorie grazie ai tuoi spostamenti “attivi” in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"healthy_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai consumato 4.500 calorie grazie ai tuoi spostamenti all’interno della tua città.Non inquinando ti stai tenendo in forma!!",@"BadgeDescriptor") forKey:@"healthy_level3"];

	[_titles setObject:__trCtx(@"Risparmiatore – 1 stella!!",@"BadgeDescriptor") forKey:@"money_saver_level1"];
	[_descriptions setObject:__trCtx(@"Risparmia un totale di 6 € grazie ai tuoi spostamenti sostenibili in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"money_saver_level1"];
	[_greetings setObject:__trCtx(@"Grande! Hai evitato una spesa totale di 6 € grazie ai tuoi spostamenti sostenibili all’interno della tua città.Risparmiando, hai dato un grande apporto alla mobilità sostenibile cittadina!",@"BadgeDescriptor") forKey:@"money_saver_level1"];

	[_titles setObject:__trCtx(@"Risparmiatore – 2 stelle!!",@"BadgeDescriptor") forKey:@"money_saver_level2"];
	[_descriptions setObject:__trCtx(@"Risparmia un totale di 12 € grazie ai tuoi spostamenti sostenibili in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"money_saver_level2"];
	[_greetings setObject:__trCtx(@"Grande! Hai evitato una spesa totale di 12 € grazie ai tuoi spostamenti sostenibili all’interno della tua città.Risparmiando, hai dato un grande apporto alla mobilità sostenibile cittadina!",@"BadgeDescriptor") forKey:@"money_saver_level2"];

	[_titles setObject:__trCtx(@"Risparmiatore – 3 stelle!!",@"BadgeDescriptor") forKey:@"money_saver_level3"];
	[_descriptions setObject:__trCtx(@"Risparmia un totale di 24 € grazie ai tuoi spostamenti sostenibili in ambito urbano ed otterrai questo badges! ",@"BadgeDescriptor") forKey:@"money_saver_level3"];
	[_greetings setObject:__trCtx(@"Grande! Hai evitato una spesa totale di 24 € grazie ai tuoi spostamenti sostenibili all’interno della tua città.Risparmiando, hai dato un grande apporto alla mobilità sostenibile cittadina!",@"BadgeDescriptor") forKey:@"money_saver_level3"];

	return self;
}

@end

