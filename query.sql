-- 1. Prikaži popis svih turnira
SELECT 
    c.name AS cup_name,
    EXTRACT(YEAR FROM c.started) AS year,
    t.name AS town_name,
    w.name AS winner_team
FROM Cups c
LEFT JOIN Towns t ON c.town_id = t.town_id
LEFT JOIN Teams w ON c.winner_id = w.team_id;

-- 2. Prikaži sve timove koji sudjeluju na određenom turniru
SELECT 
    tm.name AS team_name,
    CONCAT(p.first_name, ' ', p.last_name) AS captain
FROM CupTeamRel ctr
JOIN Teams tm ON ctr.team_id = tm.team_id
LEFT JOIN Players p ON p.team_id = tm.team_id AND p.is_captain = TRUE
WHERE ctr.cup_id = 1;

-- 3. Prikaži sve igrače iz određenog tima
SELECT 
    first_name,
    last_name,
    birth_date,
    field_position,
    is_captain
FROM Players
WHERE team_id = 1;

-- 4. Prikaži sve utakmice određenog turnira
SELECT 
    g.game_date,
    ht.name AS home_team,
    at.name AS away_team,
    g.goals_home,
    g.goals_away,
    cs.stage AS cup_stage
FROM Games g
JOIN Teams ht ON g.home_team = ht.team_id
JOIN Teams at ON g.away_team = at.team_id
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
WHERE g.cup_id = 1;

-- 5. Prikaži sve utakmice određenog tima kroz sve turnire
SELECT 
    g.game_id,
    g.game_date,
    ht.name AS home_team,
    at.name AS away_team,
    g.goals_home,
    g.goals_away,
    cs.stage
FROM Games g
JOIN Teams ht ON g.home_team = ht.team_id
JOIN Teams at ON g.away_team = at.team_id
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
WHERE 1 IN (g.home_team, g.away_team);

-- 6. Izlistati sve događaje (golovi, kartoni) za određenu utakmicu
SELECT 
    ge.e_type,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    ge.game_min,
    ge.red_card,
    ge.yellow_card
FROM GameEvents ge
JOIN Players p ON ge.player_id = p.player_id
WHERE ge.game_id = 45;

-- 7. Prikaži sve igrače koji su dobili žuti ili crveni karton na cijelom turniru
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    t.name AS team_name,
    g.game_id,
    ge.game_min,
    ge.red_card,
    ge.yellow_card
FROM GameEvents ge
JOIN Games g ON ge.game_id = g.game_id
JOIN Players p ON ge.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
WHERE g.cup_id = 1
  AND (ge.red_card = TRUE OR ge.yellow_card = TRUE);

-- 8. Prikaži sve strijelce turnira
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    t.name AS team_name,
    COUNT(*) AS goals
FROM GameEvents ge
JOIN Games g ON ge.game_id = g.game_id
JOIN Players p ON ge.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
WHERE ge.e_type = 'goal'
  AND g.cup_id = 1
GROUP BY player_name, team_name
ORDER BY goals DESC;

-- 9. Prikaži tablicu bodova za određeni turnir
SELECT 
    tm.name AS team_name,
    ctr.points,
    ctr.num_goals,
    ctr.stage
FROM CupTeamRel ctr
JOIN Teams tm ON ctr.team_id = tm.team_id
WHERE ctr.cup_id = 1
ORDER BY ctr.points DESC, ctr.num_goals DESC;

-- 10. Prikaži sve finalne utakmice u povijesti
SELECT 
    g.game_id,
    g.game_date,
    ht.name AS home_team,
    at.name AS away_team,
    g.winner_id
FROM Games g
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
JOIN Teams ht ON g.home_team = ht.team_id
JOIN Teams at ON g.away_team = at.team_id
WHERE cs.stage = 'f';

-- 11. Prikaži sve vrste utakmica
SELECT 
    cs.stage,
    COUNT(*) AS match_count
FROM Games g
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
GROUP BY cs.stage
ORDER BY match_count DESC;

-- 12. Prikaži sve utakmice odigrane na određeni datum
SELECT 
    g.game_date,
    ht.name AS home_team,
    at.name AS away_team,
    g.goals_home,
    g.goals_away,
    cs.stage
FROM Games g
JOIN Teams ht ON g.home_team = ht.team_id
JOIN Teams at ON g.away_team = at.team_id
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
WHERE DATE(g.game_date) = NOW();

-- 13. Prikaži igrače koji su postigli najviše golova na određenom turniru
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    t.name AS team_name,
    COUNT(*) AS goals
FROM GameEvents ge
JOIN Games g ON ge.game_id = g.game_id
JOIN Players p ON ge.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
WHERE ge.e_type = 'goal'
  AND g.cup_id = 1
GROUP BY player_name, team_name
ORDER BY goals DESC;

-- 14. Prikaži sve turnire na kojima je određeni tim sudjelovao
SELECT 
    c.name AS cup_name,
    EXTRACT(YEAR FROM c.started) AS year,
    ctr.stage AS final_stage
FROM CupTeamRel ctr
JOIN Cups c ON ctr.cup_id = c.cup_id
WHERE ctr.team_id = 1
ORDER BY year DESC;

-- 15. Pronađi pobjednika turnira na temelju odigranih utakmica
SELECT 
    t.name AS winner
FROM Games g
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
JOIN Teams t ON g.winner_id = t.team_id
WHERE g.cup_id = 5
  AND cs.stage = 'f';

-- 16. Za svaki turnir ispiši broj timova i igrača
SELECT 
    c.cup_id,
    c.name AS cup_name,
    COUNT(DISTINCT ctr.team_id) AS team_count,
    COUNT(DISTINCT p.player_id) AS player_count
FROM Cups c
LEFT JOIN CupTeamRel ctr ON c.cup_id = ctr.cup_id
LEFT JOIN Players p ON ctr.team_id = p.team_id
GROUP BY c.cup_id, c.name;

-- 17. Najbolji strijelci po timu
SELECT 
    t.team_id,
    t.name AS team_name,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    COUNT(*) AS goals
FROM GameEvents ge
JOIN Players p ON ge.player_id = p.player_id
JOIN Teams t ON p.team_id = t.team_id
WHERE ge.e_type = 'goal'
GROUP BY t.team_id, team_name, player_name
ORDER BY t.team_id, goals DESC;

-- 18. Utakmice nekog suca
SELECT 
    g.game_id,
    g.game_date,
    ht.name AS home_team,
    at.name AS away_team,
    g.goals_home,
    g.goals_away,
    cs.stage
FROM Games g
JOIN Teams ht ON g.home_team = ht.team_id
JOIN Teams at ON g.away_team = at.team_id
JOIN CupStage cs ON g.cup_stage_id = cs.stage_id
WHERE g.ref_id = 1
ORDER BY g.game_date;


