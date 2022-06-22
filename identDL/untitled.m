j=1;
for o = 1:size(holi')
if holi(o)== i(j)
    hola(o)=holi(o);
    if j< size(i)
    j=j+1;
    end
end
end
plot( holi, 'Color', 'k', 'LineWidth',3);
hold on;
plot( hola, 'Color', 'red', 'LineWidth',3);