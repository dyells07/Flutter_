using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ApplicationModels;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;
using System;
using System.Collections.Generic;
using System.Linq;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Backend Project", Version = "v1" });
    c.DocumentFilter<SwaggerExcludeFilter>(); // Exclude undesired endpoints
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Application");
    });
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

public class SwaggerIgnoreConvention : IControllerModelConvention
{
    public void Apply(ControllerModel controller)
    {
        if (!controller.ControllerType.GetCustomAttributes(typeof(IncludeInSwaggerAttribute), true).Any())
        {
            controller.ApiExplorer.IsVisible = false;
        }
    }
}

public class IncludeInSwaggerAttribute : Attribute
{
}

public class SwaggerExcludeFilter : IDocumentFilter
{
    public void Apply(OpenApiDocument swaggerDoc, DocumentFilterContext context)
    {
        var controllers = context.ApiDescriptions.Select(x => x.ActionDescriptor.RouteValues["controller"]).Distinct();
        var controllersToExclude = controllers.Where(x => !x.Contains(nameof(IncludeInSwaggerAttribute))).ToList();

        foreach (var controllerToExclude in controllersToExclude)
        {
            var pathsToRemove = swaggerDoc.Paths.Where(p => p.Key.Contains(controllerToExclude)).ToList();
            foreach (var pathToRemove in pathsToRemove)
            {
                swaggerDoc.Paths.Remove(pathToRemove.Key);
            }
        }
    }
}
