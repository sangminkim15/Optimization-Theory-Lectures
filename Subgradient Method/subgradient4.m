function [] = subgradient4 ()

load('hw8.mat', 'A');
load('hw8.mat', 'b');

% Initialize x(0), f(0)
x = zeros(100, 1);
f = norm(A * x - b, 1);

% Subgradient
y = A * x - b;
dy = zeros(500, 1);
for idx = 1 : 500
    if y(idx) > 0
        dy(idx, 1) = 1;
    else
        if y(idx) < 0
            dy(idx, 1) = -1;
        else
            dy(idx, 1) = 0;
        end
    end
end

df = A' * dy;

jdx = 0;
iterations = [];
temp = [];

while true
    % Subgradient Method - Fixed Step Size
    jdx = jdx + 1;
    x_nxt = x - (0.01) * df;
    f_nxt = norm(A * x_nxt - b, 1);
    
    % Next Subgradient
    y_nxt = A * x_nxt - b;
    dy_nxt = zeros(500, 1);
    for kdx = 1 : 500
        if y_nxt(kdx) > 0
            dy_nxt(kdx, 1) = 1;
        else
            if y_nxt(kdx) < 0
                dy_nxt(kdx, 1) = -1;
            else
                dy_nxt(kdx, 1) = 0;
            end
        end
    end
    
    df_nxt = A' * dy_nxt;
    
    iterations = horzcat(iterations, jdx);
    temp = horzcat(temp, f_nxt);
    
    if abs(f - f_nxt) < 1e-3
        break
    end
    
    x = x_nxt;
    f = f_nxt;
    df = df_nxt;
end

semilogy(iterations, temp, 'LineWidth', 1.5);

end