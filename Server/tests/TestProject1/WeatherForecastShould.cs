using Microsoft.AspNetCore.Mvc.Testing;
using Shouldly;
using System.Net.Http.Json;

namespace TestProject1;

public class WeatherForecastShould(WebApplicationFactory<Program> factory) : IClassFixture<WebApplicationFactory<Program>>
{
    [Fact]
    public async Task Test1()
    {
        var client = factory.CreateClient();

        using var response = await client.GetAsync("api/weatherforecast", TestContext.Current.CancellationToken);

        response.EnsureSuccessStatusCode();
        (await response.Content.ReadFromJsonAsync<IEnumerable<WeatherForecast>>(cancellationToken: TestContext.Current.CancellationToken)).ShouldNotBeEmpty();
    }
}
