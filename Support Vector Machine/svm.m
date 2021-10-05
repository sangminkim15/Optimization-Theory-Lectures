function [a, b] = svm (X, Y, class, gamma)

class = 2 * class - 1;

cvx_begin

variable p(2,1)
variable q(1,1)

SUM = 0;
for idx = 1 : length(class)
    SUM = SUM + max([0, 1 - class(idx) * (p(1,1) * X(idx) + p(2,1) * Y(idx) + q)]);
end

minimize (gamma * norm(p) + SUM)

cvx_end

a = p;
b = q;

end