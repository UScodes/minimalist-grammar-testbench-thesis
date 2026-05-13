token_case([one]).
token_case([two]).
token_case([three]).
token_case([four]).
token_case([five]).
token_case([six]).
token_case([seven]).
token_case([eight]).
token_case([nine]).

token_case([ten]).
token_case([eleven]).
token_case([twelve]).
token_case([thirteen]).
token_case([fifteen]).

token_case([four,teen]).
token_case([eight,een]).

token_case([twenty]).
token_case([thirty]).
token_case([fifty]).

token_case([twenty_,one]).
token_case([twenty_,two]).
token_case([twenty_,three]).
token_case([twenty_,four]).
token_case([twenty_,five]).
token_case([twenty_,six]).
token_case([twenty_,seven]).
token_case([twenty_,eight]).
token_case([twenty_,nine]).

token_case([thirty_,one]).
token_case([thirty_,two]).
token_case([thirty_,three]).
token_case([thirty_,four]).
token_case([thirty_,five]).
token_case([thirty_,six]).
token_case([thirty_,seven]).
token_case([thirty_,eight]).
token_case([thirty_,nine]).

token_case([fifty_,one]).
token_case([fifty_,two]).
token_case([fifty_,three]).
token_case([fifty_,four]).
token_case([fifty_,five]).
token_case([fifty_,six]).
token_case([fifty_,seven]).
token_case([fifty_,eight]).
token_case([fifty_,nine]).

% reverse parse-failure cases
token_case([six,teen]).
token_case([seven,teen]).
token_case([nine,teen]).

% optional malformed token
token_case([teen]).

% reverse generation-failure candidates
token_case([forty_,four]).
token_case([sixty_,four]).
