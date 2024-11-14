clc 
close all
clear all

node = {'London', 'Zurich', 'Milan', 'Paris', 'Wien', 'Istanbul', 'Kyoto'};

arc = [1 2 3; ...
       2 1 3; ...
       1 4 10; ... 
       4 1 10; ...
       2 3 1; ...
       3 2 1; ... 
       3 4 13; ... 
       4 3 13; ... 
       3 5 8; ...
       5 3 8; ...
       4 5 3; ...
       5 4 3; ...
       5 6 6; ...
       6 5 6; ...
       6 4 2; ...
       4 6 2; ...
       6 7 4; ...
       7 6 4; ...
       2 7 18; ... 
       7 2 18];

first_id = find(strcmp(node,'Milan'));
final_id = find(strcmp(node,'Kyoto'));   

ttn = inf(size(node));
ttn(first_id) = 0;

prev_id = nan(size(node));
prev_id(first_id) = first_id;

visited_id = [];
id_to_visit = [first_id];

while ~isempty(id_to_visit)
    % Find the node with the minimum cost in the set of nodes to visit
    [~, idx] = min(ttn(id_to_visit));
    current_node = id_to_visit(idx);
    
    % Remove the current node from the set of nodes to visit
    id_to_visit(idx) = [];
    
    % Add the current node to the set of already visited nodes
    visited_id = [visited_id, current_node];
    
    % Find the arcs leaving the current node
    outgoing_arcs = arc(arc(:,1) == current_node, :);
    reachable_nodes = unique(outgoing_arcs(:,2));
    
    % For each reachable node
    for next_node = reachable_nodes'
        % Calculate the tentative total cost
        tentative_cost = ttn(current_node) + outgoing_arcs(outgoing_arcs(:,2) == next_node, 3);
        
        % Check if the new cost is smaller than the existing cost
        if tentative_cost < ttn(next_node)
            % Update the cost and previous node
            ttn(next_node) = tentative_cost;
            prev_id(next_node) = current_node;
            
            % Add the node to the set of nodes to visit if not already there
            if ~ismember(next_node, id_to_visit)
                id_to_visit = [id_to_visit, next_node];
            end
        end
    end
end

% Reconstruct the path
path = final_id;
while path(1) ~= first_id
    path = [prev_id(path(1)), path];
end

% Reverse the order of the path
path = fliplr(path);

disp('Shortest Path:');
disp(node(path));
disp(['Total Cost: ', num2str(ttn(final_id))]);

