using Microsoft.EntityFrameworkCore;
using todobackend.Data;
using todobackend.Services;

internal class Program
{
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.
        builder.Services.AddDbContext<AppDbContext>(options =>
        {
            options.UseNpgsql(builder.Configuration.GetConnectionString("CadenaSQL"));
        });

        builder.Services.AddCors(options =>
        {
            options.AddPolicy("AllowAllOrigins", policy =>
            {
                policy.AllowAnyOrigin()   // Permite cualquier origen
                      .AllowAnyMethod()   // Permite cualquier método (GET, POST, PUT, DELETE, etc.)
                      .AllowAnyHeader();  // Permite cualquier encabezado
            });
        });

        builder.Services.AddScoped<TaskData>();
        builder.Services.AddScoped<TaskService>();

        builder.Services.AddControllers();
        // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
        builder.Services.AddEndpointsApiExplorer();
        builder.Services.AddSwaggerGen();

        var app = builder.Build();

        // Configure the HTTP request pipeline.
        if (app.Environment.IsDevelopment())
        {
            app.UseDeveloperExceptionPage();
            app.UseSwagger();
            app.UseSwaggerUI();
        }

        //app.UseHttpsRedirection();

        var applicationBuilder = app.UseCors("AllowAllOrigins");

        app.UseAuthorization();

        app.MapControllers();

        app.Run();
    }
}