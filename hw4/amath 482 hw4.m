load fisheriris

[train_image, train_label] = mnist_parse('train-images-idx3-ubyte', 'train-labels-idx1-ubyte');
[test_image, test_label] = mnist_parse('t10k-images-idx3-ubyte', 't10k-labels-idx1-ubyte');

train_image = im2double(reshape(train_image, size(train_image, 1) * size(train_image, 2), []).'); 
train_label = im2double(train_label);
train_image = train_image';

test_image = im2double(reshape(test_image, size(test_image, 1) * size(test_image, 2), []).');
test_label = im2double(test_label);
test_image = test_image';

mn = mean(train_image, 2);
train_image = double(train_image) - repmat(mn, 1, length(train_image)); 

[U, S, V] = svd(train_image, 'econ');

energy = 0;
total = sum(diag(S));

thres = 0.9;
r = 0;

while energy < thres
    r = r + 1;
    energy = energy + S(r, r) / total;
end

rank = r;

train_image = (U(:, 1:rank))' * train_image;
test_image = (U(:, 1:rank))' * test_image;

lamda = diag(S) .^ 2;

for i = [1,2]
    Projection_idx = train_image(:, find(train_label == i));
    plot3(Projection_idx(1,:), Projection_idx(2,:), Projection_idx(3,:),...
          'o', 'DisplayName', num2str(i)); 
    hold on
end

scrsz = get(groot, 'ScreenSize'); 

tr = train_image;
te = test_image;


dimension = size(train_image,1);
Sw = zeros(dimension);
Sb = zeros(dimension);   
N = size(train_image, 2); 
Nt = size(test_image, 2); 
Mu = mean(train_image, 2);  

for i = [1, 2] 
    mask = (train_label ==  i);
    x = tr(:, mask);
    ni = size(x, 2);
    pi = ni / N;
    mu_i = mean(x, 2);

    Si = (x - repmat(mu_i, [1,ni]))*(x - repmat(mu_i, [1,ni]))';
    Sw = Sw + Si ;
    Sb = Sb + (mu_i - Mu) * (mu_i - Mu)';
end

M = pinv(Sw) * Sb;  
[U, D, V] = svd(M);

G2 = U(:,1:rank);
Y2 = G2' * tr;

data2d_fig = figure('Name', '2-D Plot');
set(data2d_fig, 'Position', [60 60 scrsz(3)-120 scrsz(4) - 140]);

for number = [1,2]
    mask = (train_label ==  number);
    a = Y2(1,mask);
    b = Y2(2,mask);
    d = [a'; b'];
    plot(d, 1*number*ones(size(d)),'o',...
        'DisplayName', num2str(number)); hold on 
    title(['LDA classifier']);
    
end
legend show

  
 ylim([-1 number+1])       


na = 1;
nb = 2;

Y = G2' * tr;
Y_t = G2'* te;

train_n= Y(:, find(train_label == na|train_label ==nb));
test_n = Y_t(:, find(test_label == na |test_label ==nb)); 

accuracy = classifyNN(test_n, train_n,...
    test_label(find(test_label == na |test_label ==nb)), ...
    train_label(find(train_label == na |train_label ==nb)));
  
%% Defining function 

function [accuracy] = classifyNN(test_data, train_data, test_label, train_label)

train_size = size(train_data, 2);
test_size = size(test_data, 2);
counter = zeros(test_size, 1);

parfor test_digit = 1:1:test_size

    test_mat = repmat(test_data(:, test_digit), [1,train_size]);
    distance = sum(abs(test_mat - train_data).^2);
    [M,I] = min(distance);
    if train_label(I) == test_label(test_digit)
        counter(test_digit) = counter(test_digit) + 1;
    end
end

accuracy = double(sum(counter)) / test_size;
end

